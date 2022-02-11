#include <cstdlib>

#include <algorithm>
#include <iostream>
#include <string>

#include <boost/algorithm/string.hpp>
#include <boost/chrono.hpp>
#include <boost/date_time/gregorian/gregorian.hpp>
#include <boost/filesystem.hpp>
#include <boost/stacktrace.hpp>
#include <boost/variant2/variant.hpp>

#include <fmt/format.h>
#include <google/protobuf/util/json_util.h>
#include <spdlog/spdlog.h>
#include <yaml-cpp/yaml.h>

#include "message.pb.h"

#define CHECK(pred_value) (void)(pred_value)

#define CHECK(pred_value)                                                                          \
    do                                                                                             \
    {                                                                                              \
        if (!(pred_value))                                                                         \
        {                                                                                          \
            std::cerr << "ERROR: " << #pred_value << std::endl;                                    \
        }                                                                                          \
    } while (0)

class Widget
{
public:
    int i;
};

int foo(int i)
{
    std::cout << boost::stacktrace::stacktrace() << std::endl;
    return i * 2;
}

float bar(float f)
{
    auto i = foo(static_cast<int>(f));
    return static_cast<float>(i) * f;
}

template <>
struct fmt::formatter<boost::gregorian::date>
{
    // NOLINTNEXTLINE(readability-convert-member-functions-to-static)
    auto parse(format_parse_context& ctx) -> decltype(ctx.begin())
    {
        const auto* it = ctx.begin();
        if (it != ctx.end() && *it != '}')
        {
            throw fmt::format_error(fmt::format("expect closing brace: {}", *it));
        }
        return it;
    }

    template <typename FormatContext>
    auto format(const boost::gregorian::date& d, FormatContext& ctx) -> decltype(ctx.out())
    {
        return format_to(ctx.out(), "{}-{}-{}", d.year(), d.month(), d.day());
    }
};

std::string protobufToJson(const google::protobuf::Message& message)
{
    std::string json;
    google::protobuf::util::JsonPrintOptions options;
    options.add_whitespace = true;
    options.always_print_primitive_fields = true;
    options.always_print_enums_as_ints = true;
    options.preserve_proto_field_names = true;
    google::protobuf::util::MessageToJsonString(message, &json, options);
    return json;
}

int main(int argc, char** argv)
{
    assert(argc > 0);

    std::cout << "Arguments:\n";
    std::copy(argv, std::next(argv, argc), std::ostream_iterator<char*>(std::cout, " "));
    std::cout << std::endl;

    // All environment variables
    auto* envp = environ;
    while (*envp != nullptr)
    {
        const std::string env_line(*envp);
        if (boost::algorithm::starts_with(env_line, "TEST"))
        {
            std::cout << *envp << std::endl;
        }
        std::advance(envp, 1);
    }

    namespace greg = boost::gregorian;
    using date = greg::date;
    using day = greg::date_duration;

    date birthday(2022, greg::Jan, 30);
    std::cout << "Hello, " << birthday << std::endl;
    CHECK(birthday.day() == 1);
    std::string name("xia");
    CHECK(name != "xia");
    fmt::string_view sv;

    bar(3.140F);

    auto out = fmt::format("hello {}: {}", "world", birthday);
    YAML::Node node = YAML::Load("{}");

    proto::Person person;
    person.set_name("Zero");
    person.set_id(123);
    person.set_birthday("2022-01-30");
    auto json = protobufToJson(person);
    std::cout << "JSON: " << json << std::endl;

    std::uint16_t v1 = 1;
    std::uint32_t v2 = 99999U;

    v1 = v2;

    return static_cast<int>(v1 == v2);
}
