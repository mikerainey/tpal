#pragma once

#include "mcsl_stats.hpp"
#include "mcsl_logging.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Heartbeat scheduling parameters */

static constexpr
uint64_t dflt_kappa_usec = 100;
  
uint64_t kappa_usec = dflt_kappa_usec, kappa_cycles;

static inline
void assign_kappa(uint64_t cpu_freq_khz, uint64_t _kappa_usec) {
  kappa_usec = _kappa_usec;
  uint64_t cycles_per_usec = cpu_freq_khz / 1000l;
  kappa_cycles = cycles_per_usec * kappa_usec;
}

static constexpr
int dflt_software_polling_K = 128;
  
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

/*---------------------------------------------------------------------*/

template <typename T>
void zero_init(T* a, std::size_t n) {
  volatile T* b = (volatile T*)a;
  for (std::size_t i = 0; i < n; i++) {
    b[i] = 0;
  }
}
  
} // end namespace
