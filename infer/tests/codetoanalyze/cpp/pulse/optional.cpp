/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <vector>
#include <string>
#include <memory>

namespace folly {

template <class Value>
class Optional;

struct None {
  enum class _secret { _token };
  explicit constexpr None(_secret) {}
};
constexpr None none{None::_secret::_token};

template <class Value>
class Optional {
 public:
  typedef Value value_type;

  constexpr Optional();

  Optional(const Optional& src);

  constexpr Optional(const None&) noexcept;

  constexpr Optional(const Value& newValue);

  void assign(const None&);

  void assign(const Optional& src);

  Optional& operator=(None) noexcept {
    reset();
    return *this;
  }

  Optional& operator=(const Optional& other) {
    assign(other);
    return *this;
  }

  template <class... Args>
  Value& emplace(Args&&... args);

  void reset() noexcept;

  constexpr const Value& value() const&;

  constexpr bool has_value() const noexcept;

  constexpr explicit operator bool() const noexcept { return has_value(); }

  constexpr const Value* operator->() const { return &value(); }

  Value* get_pointer();

  template <class U>
  constexpr Value value_or(U&& dflt) const&;
};
} // namespace folly

int not_none_ok() {
  folly::Optional<int> foo{5};
  return foo.value();
}

// missing a more precise model for
// constructing an optional from a value
int not_none_check_value_ok_FP() {
  folly::Optional<int> foo{5};
  int x = foo.value();
  if (x != 5) {
    folly::Optional<int> foo{folly::none};
    return foo.value();
  }
  return x;
}

int none_check_ok() {
  folly::Optional<int> foo{folly::none};
  if (foo) {
    return foo.value();
  }
  return -1;
}

int none_no_check_bad() {
  folly::Optional<int> foo{folly::none};
  return foo.value();
}

int none_copy_ok() {
  folly::Optional<int> foo{5};
  folly::Optional<int> bar{foo};
  return bar.value();
}

int none_copy_bad() {
  folly::Optional<int> foo{folly::none};
  folly::Optional<int> bar{foo};
  return bar.value();
}

int assign_ok() {
  folly::Optional<int> foo{5};
  folly::Optional<int> bar{foo};
  foo = folly::none;
  return bar.value();
}

int assign_bad() {
  folly::Optional<int> foo{folly::none};
  folly::Optional<int> bar{5};
  int sum = bar.value();
  bar = foo;
  sum += bar.value();
  return sum;
}

int assign2_bad() {
  folly::Optional<int> foo{5};
  int sum = foo.value();
  foo = folly::none;
  sum += foo.value();
  return sum;
}

struct State {
  std::vector<int> vec;
};

void emplace(folly::Optional<State> state) {
  if (state) {
    state.emplace();
  }
  auto pos = state->vec.begin();
}

/* There is a bug in the frontend T89443328 */
void operator_arrow_bad_FN() { emplace(folly::none); }

void get_pointer_check_none_check_ok() {
  folly::Optional<int> foo{folly::none};
  if (int* v = foo.get_pointer()) {
    *v = 42;
  }
}

void get_pointer_check_value_check_ok() {
  folly::Optional<int> foo{5};
  if (int* ptr = foo.get_pointer()) {
    *ptr = 42;
  }
}

void get_pointer_no_check_none_check_bad() {
  folly::Optional<int> foo{folly::none};
  int* ptr = foo.get_pointer();
  *ptr = 42;
}

void get_pointer_no_check_value_check_ok() {
  folly::Optional<int> foo{5};
  int* ptr = foo.get_pointer();
  *ptr = 42;
}

int value_or_check_empty_ok() {
  folly::Optional<int> foo{folly::none};
  if (foo.value_or(0) > 0) {
    return foo.value();
  }
  return -1;
}

int FP_value_or_check_value_ok() {
  folly::Optional<int> foo{5};
  int x = foo.value_or(0);
  if (x != 5) {
    folly::Optional<int> foo{folly::none};
    return foo.value();
  }
  return -1;
}

int test_trace_ref() {
  folly::Optional<int> foo{5};
  int sum = foo.value();
  foo = folly::none;
  const int& x = foo.value();
  sum += x;
  return sum;
}

struct StringWrapper {
  static folly::Optional<StringWrapper> get_optional() {
    return StringWrapper();
  };
  std::string x;
};

std::string get_optional_string_wrapper_ok() {
  return StringWrapper::get_optional().value().x.data();
}


struct Container final {
  std::vector<int> _vec;

  Container() : _vec(std::vector<int>{}) {}

  folly::Optional<int> getFirst() const {
    if (_vec.empty()) {
      return folly::none;
    }
    return _vec.front();
  }

  int optional_check_ok(const Container& c) {
    if (!c._vec.empty()) {
      return c.getFirst().value();
    }
    return -1;
  }
};




struct Node {
  std::shared_ptr<int> shared;

  folly::Optional<std::shared_ptr<int>> getShared() const {
    if (shared == nullptr) {
      return folly::none;
    }
    return shared;
  }
};

int FP_smart_pointer(const Node& node) {
  if (node.getShared().has_value()) {
    return *(node.getShared().value());
  }
  return -1;
}
