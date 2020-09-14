#include <atomic>
#include <functional>

template <typename ET, typename F>
inline bool write_min(std::atomic<ET> *a, ET b, F less) {
  ET c; 
  bool r = 0;
  do {
    c = a->load();
  } while (less(b,c) && !(r=std::atomic_compare_exchange_strong(a, &c, b)));
  return r;
}

template<class IntegerPred>
std::size_t find_if_index(std::size_t n, IntegerPred p) {
  std::size_t granularity = 10000;
  std::size_t j;
  for (j = 0; j < std::min(granularity, n); j++) {
    if (p(j)) {
      return j;
    }
  }
  if (j == n) {
    return n;
  }
  std::atomic<std::size_t> i(j);
  std::size_t start = granularity;
  std::size_t block_size = 2 * granularity;
  i.store(n);
  while (start < n) {
    std::size_t end = std::min(n, start + block_size);
    for (j = start; j < end; j++) {
      if (p(j)) { 
        write_min(&i, j, std::less<size_t>());
      }
    }
    if (i < n) {
      return i;
    }
    start += block_size;
    block_size *= 2;
  }
  return n;
}

template <class Seq1, class Seq2, class Compare>
bool lexicographical_compare(const Seq1& s1, const Seq2& s2, const Compare& less) {
  size_t m = std::min(s1.size(), s2.size());
  size_t i = find_if_index(m, [&] (size_t i) {
    return less(s1[i],s2[i]) || less(s2[i],s1[i]);});
  return (i < m) ? (less(s1[i], s2[i])) : (s1.size() < s2.size());
}

bool string_compare(const std::string& s1, const std::string& s2) {
  return lexicographical_compare(s1, s2, [] (char c1, char c2) { return c1 < c2; });
}
