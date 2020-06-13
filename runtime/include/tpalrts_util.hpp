#pragma once

#include <map>

#include "mcsl_stats.hpp"
#include "mcsl_logging.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
  
uint64_t kappa_usec;

uint64_t kappa_cycles;

/*---------------------------------------------------------------------*/
/* Stats */

class stats_configuration {
public:

#ifdef SPAWNBENCH_STATS
  static constexpr
  bool enabled = true;
#else
  static constexpr
  bool enabled = false;
#endif

  using counter_id_type = enum counter_id_enum {
    nb_promotions,
    nb_steals,
    nb_counters
  };

  static
  const char* name_of_counter(counter_id_type id) {
    std::map<counter_id_type, const char*> names;
    names[nb_promotions] = "nb_promotions";
    names[nb_steals] = "nb_steals";
    return names[id];
  }
  
};

using stats = mcsl::stats_base<stats_configuration>;

/*---------------------------------------------------------------------*/
/* Logging */

#ifdef SPAWNBENCH_LOGGING
using logging = mcsl::logging_base<true>;
#else
using logging = mcsl::logging_base<false>;
#endif
  
} // end namespace
