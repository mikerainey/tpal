#include <string>
#include <fstream>
#include <streambuf>
#include <sstream>
#include <set>
#include <vector>
#include <deque>

#include "cmdline.hpp"

int main() {
  std::string file = deepsea::cmdline::parse_or_default_string("file", "");
  if (file == "") {
    std::cout << "bogus input file " << file << std::endl;
    return 1;
  }
  
  std::ifstream t(file);
  std::string results_str((std::istreambuf_iterator<char>(t)),
			  std::istreambuf_iterator<char>());

  auto is_start_marker = [] (std::string& s) {
    return s == "###start-experiment###";
  };

  auto is_end_marker = [] (std::string& s) {
    return s == "###end-experiment###";
  };
  
  auto snip = [&] (std::string& s) {
    std::istringstream iss(s);
    bool saw_header = false;
    for (std::string line; std::getline(iss, line); ) {
      if (is_end_marker(line)) {
	return;
      }
      if (is_start_marker(line)) {
	saw_header = true;
	continue;
      }
      if (! saw_header) {
	continue;
      }
      std::cout << line << std::endl;
    }
  };

  snip(results_str);

  return 0;
}
