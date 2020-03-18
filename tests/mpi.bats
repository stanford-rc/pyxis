#!/usr/bin/env bats

load ./common

@test "PMIx mount" {
    run_srun --mpi=pmix --ntasks=4 --container-image=ubuntu:18.04 sh -c '[ -n "${PMIX_SERVER_TMPDIR}" ] && findmnt "${PMIX_SERVER_TMPDIR:-error}"'
}

@test "PMIx environment variables" {
    run_srun --mpi=pmix --ntasks=4 --container-image=ubuntu:18.04 bash -c '[ -n "${PMIX_RANK}" ]'
    run_srun --mpi=pmix --ntasks=4 --container-image=ubuntu:18.04 bash -c '[ -n "${PMIX_MCA_psec}" ] && [ "${PMIX_MCA_psec}" == "${PMIX_SECURITY_MODE}" ]'
    run_srun --mpi=pmix --ntasks=4 --container-image=ubuntu:18.04 bash -c '[ -n "${PMIX_MCA_gds}" ] && [ "${PMIX_MCA_gds}" == "${PMIX_GDS_MODULE}" ]'
    run_srun --mpi=pmix --ntasks=4 --container-image=ubuntu:18.04 bash -c '[ -n "${PMIX_MCA_ptl}" ] && [ "${PMIX_MCA_ptl}" == "${PMIX_PTL_MODULE}" ]'
}

@test "PMI2 file descriptor" {
    run_srun --mpi=pmi2 --ntasks=4 --container-image=ubuntu:18.04 bash -c '[ -n "${PMI_FD}" ] && realpath /proc/self/fd/${PMI_FD} | grep -q socket'
}

@test "PMI2 environment variables" {
    run_srun --mpi=pmi2 --ntasks=4 --container-image=ubuntu:18.04 bash -c '[ -n "${PMI_RANK}" ]'
    run_srun --mpi=pmi2 --ntasks=4 --container-image=ubuntu:18.04 bash -c '[ -n "${PMI_SIZE}" ] && [ "${PMI_SIZE}" -eq 4 ]'
}
