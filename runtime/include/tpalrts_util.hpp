#pragma once

#include "mcsl_stats.hpp"
#include "mcsl_logging.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Heartbeat scheduling parameter kappa */

uint64_t kappa_usec;

uint64_t kappa_cycles;

static inline
void set_kappa_usec(double cpu_freq_ghz, uint64_t _kappa_usec) {
  kappa_usec = _kappa_usec;
  auto kappa_nsec = kappa_usec * 1000;
  kappa_cycles = (uint64_t)(cpu_freq_ghz * kappa_nsec);
}

/*---------------------------------------------------------------------*/
/* Stats */

class stats_configuration {
public:

#ifdef TPALRTS_STATS
  static constexpr
  bool enabled = true;
#else
  static constexpr
  bool enabled = false;
#endif

  using counter_id_type = enum counter_id_enum {
    nb_promotions,
    nb_steals,
    nb_heartbeats,
    nb_counters
  };

  static
  const char* name_of_counter(counter_id_type id) {
    const char* names[nb_counters];
    names[nb_promotions] = "nb_promotions";
    names[nb_steals] = "nb_steals";
    names[nb_heartbeats] = "nb_heartbeats";
    return names[id];
  }
  
};

using stats = mcsl::stats_base<stats_configuration>;

/*---------------------------------------------------------------------*/
/* Logging */

#ifdef TPALRTS_LOGGING
using logging = mcsl::logging_base<true>;
#else
using logging = mcsl::logging_base<false>;
#endif
  
} // end namespace
