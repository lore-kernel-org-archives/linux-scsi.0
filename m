From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Mon, 25 Feb 2019 10:42:47 +0530
Message-ID: <CAK=zhgom2ap3ahHrEPYQ0jRqbi4AqB09VF_1gLJADF_fS_ZcVg@mail.gmail.com>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com> <20190222152433.CF1822086A@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190222152433.CF1822086A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 22, 2019 at 8:54 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v4.20.11, v4.19.24, v4.14.102, v4.9.159, v4.4.175, v3.18.135.
>
> v4.19.24: Failed to apply! Possible dependencies:
>     919d8a3f3fef ("scsi: mpt3sas: Convert uses of pr_<level> with MPT3SAS_FMT to ioc_<level>")
>
> v4.14.102: Failed to apply! Possible dependencies:
>     016d5c35e278 ("scsi: mpt3sas: SGL to PRP Translation for I/Os to NVMe devices")
>     02a386df3678 ("scsi: mpt3sas: open-code _scsih_scsi_lookup_get()")
>     05303dfb7380 ("scsi: mpt3sas: use list_splice_init()")
>     12e7c6782bc5 ("scsi: mpt3sas: Introduce mpt3sas_get_st_from_smid()")
>     182ac784b41f ("scsi: mpt3sas: Introduce Base function for cloning.")
>     22ae5a3c2599 ("scsi: mpt3sas: Introduce API to get BAR0 mapped buffer address")
>     494f401bcd07 ("scsi: mpt3sas: Fix sparse warnings")
>     6a2d4618aef3 ("scsi: mpt3sas: separate out _base_recovery_check()")
>     6da999fe5a92 ("scsi: mpt3sas: simplify mpt3sas_scsi_issue_tm()")
>     74fcfa5371b7 ("scsi: mpt3sas: simplify task management functions")
>     93204b782a88 ("scsi: mpt3sas: Lockless access for chain buffers.")
>     9961c9bbf2b4 ("scsi: mpt3sas: check command status before attempting abort")
>     aff39e61218f ("scsi: mpt3sas: Added support for nvme encapsulated request message.")
>     b0cd285eb57c ("scsi: mpt3sas: always use first reserved smid for ioctl passthrough")
>     ba4494d47bd0 ("scsi: mpt3sas: set default value for cb_idx")
>     c102e00cf4b8 ("scsi: mpt3sas: API 's to support NVMe drive addition to SML")
>     cd5897eda27d ("scsi: mpt3sas: Fix nvme drives checking for tlr.")
>     d8335ae2b453 ("scsi: mpt3sas: fix dma_addr_t casts")
>     d88e1eaba6ee ("scsi: mpt3sas: Add nvme device support in slave alloc, target alloc and probe")
>     dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
>
> v4.9.159: Failed to apply! Possible dependencies:
>     016d5c35e278 ("scsi: mpt3sas: SGL to PRP Translation for I/Os to NVMe devices")
>     12e7c6782bc5 ("scsi: mpt3sas: Introduce mpt3sas_get_st_from_smid()")
>     307d9075a02b ("scsi: mpt3sas: Recognize and act on iopriority info")
>     494f401bcd07 ("scsi: mpt3sas: Fix sparse warnings")
>     81c16f83231a ("scsi: mpt3sas: Use the new MPI 2.6 32-bit Atomic Request Descriptors for SAS35 devices.")
>     998f26aedf41 ("scsi: mpt3sas: Added Device ID's for SAS35 devices and updated MPI header.")
>     aff39e61218f ("scsi: mpt3sas: Added support for nvme encapsulated request message.")
>     b0cd285eb57c ("scsi: mpt3sas: always use first reserved smid for ioctl passthrough")
>     ba4494d47bd0 ("scsi: mpt3sas: set default value for cb_idx")
>     c696f7b83ede ("scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path")
>     d8335ae2b453 ("scsi: mpt3sas: fix dma_addr_t casts")
>     dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
>
> v4.4.175: Failed to apply! Possible dependencies:
>     016d5c35e278 ("scsi: mpt3sas: SGL to PRP Translation for I/Os to NVMe devices")
>     12e7c6782bc5 ("scsi: mpt3sas: Introduce mpt3sas_get_st_from_smid()")
>     30158dc9bbc9 ("mpt3sas: Never block the Enclosure device")
>     307d9075a02b ("scsi: mpt3sas: Recognize and act on iopriority info")
>     5f0dfb7a9bcc ("mpt3sas: Used "synchronize_irq()"API to synchronize timed-out IO & TMs")
>     6c197093847e ("mpt3sas: Set maximum transfer length per IO to 4MB for VDs")
>     81c16f83231a ("scsi: mpt3sas: Use the new MPI 2.6 32-bit Atomic Request Descriptors for SAS35 devices.")
>     8bbb1cf63f5e ("mpt3sas: Fix warnings exposed by W=1")
>     998f26aedf41 ("scsi: mpt3sas: Added Device ID's for SAS35 devices and updated MPI header.")
>     aff39e61218f ("scsi: mpt3sas: Added support for nvme encapsulated request message.")
>     b0cd285eb57c ("scsi: mpt3sas: always use first reserved smid for ioctl passthrough")
>     b130b0d56fa9 ("mpt3sas: Added support for high port count HBA variants.")
>     ba4494d47bd0 ("scsi: mpt3sas: set default value for cb_idx")
>     c696f7b83ede ("scsi: mpt3sas: Implement device_remove_in_progress check in IOCTL path")
>     d8335ae2b453 ("scsi: mpt3sas: fix dma_addr_t casts")
>     dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
>     fd0331b32826 ("mpt3sas: Make use of additional HighPriority credit message frames for sending SCSI IO's")
>
> v3.18.135: Failed to apply! Possible dependencies:
>     03d1fb3a6578 ("mpt3sas: Fix for Asynchronous completion of timedout IO and task abort of timedout IO.")
>     12e7c6782bc5 ("scsi: mpt3sas: Introduce mpt3sas_get_st_from_smid()")
>     2b89669ae4ad ("mpt3sas: Bump mpt3sas driver version to v6.100.00.00")
>     2e26c3853206 ("mpt3sas: Update MPI2 strings to MPI2.5")
>     2ecb204d07ac ("scsi: always assign block layer tags if enabled")
>     3c5866565f37 ("mpt2sas: Use mpi headers from mpt3sas")
>     7497392a1193 ("mpt3sas: Move Gen3 HBA's device registration to a separate file")
>     7786ab6aff9c ("mpt3sas: Ported WarpDrive product SSS6200 support")
>     78f97c8f612d ("mpt2sas: Move Gen2 HBA's device registration to a separate file")
>     8a7e4c24e08f ("mpt3sas: Added mpt2sas driver definitions")
>     8f88dc41927f ("mptfusion: don't change queue type in ->change_queue_depth")
>     a03bd153b1b3 ("mpt2sas, mpt3sas: Update attribution language to Avago")
>     a62182f338b3 ("scsi: provide a generic change_queue_type method")
>     ad666a0f41d9 ("mpt2sas, mpt3sas: fix upper bound for the module parameter max_sgl_entries")
>     c75683ca13d1 ("mpt3sas : Bump mpt3sas driver version to 9.100.00.00")
>     c8b09f6fb67d ("scsi: don't set tagging state from scsi_adjust_queue_depth")
>     cb16ef384f15 ("mpt2sas: MPI2 Rev AA (2.00.19) specifications")
>     cf75d5d6aa91 ("mpt3sas: simplify ->change_queue_depth")
>     d357e84d65df ("mpt3sas: Define 'hba_mpi_version_belonged' IOC variable")
>     d42432ad6c5c ("mpt2sas: MPI2 Rev BB (2.00.20) specification and 2.00.35 header files")
>     db5ed4dfd5dd ("scsi: drop reason argument from ->change_queue_depth")
>     dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
>     f9d81cfc2315 ("mpt3sas: Bump mpt3sas Driver version to v5.100.00.00")
>     fb77bb5376a5 ("mpt3sas: Added Combined Reply Queue feature to extend up-to 96 MSIX vector support")
>
>
> How should we proceed with this patch?

Shall I prepare the patches against all the above stable kernels and
shall I post them individually? if yes then how should I mention that
the particular is for corresponding stable kernel?

Thanks,
Sreekanth

>
> --
> Thanks,
> Sasha
