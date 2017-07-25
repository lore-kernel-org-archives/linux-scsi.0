From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Tue, 25 Jul 2017 10:50:04 +0530
Message-ID: <CA+RiK66Mkm53D-Gf5YyqQx6Zt9eiGWcqX2F9yvJUrSgPQ_dZYQ@mail.gmail.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, linux-nvme@lists.infradead.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Is there any update on these patches ?

Thanks,
Suganath Prabu S

On Fri, Jul 14, 2017 at 6:52 PM, Suganath Prabu S
<suganath-prabu.subramani@broadcom.com> wrote:
> Ventura Series controller are Tri-mode. The controller and
> firmware are capable of supporting NVMe devices and
> PCIe switches to be connected with the controller. This
> patch set adds driver level support for NVMe devices and
> PCIe switches.
>
> Suganath Prabu S (13):
>   mpt3sas: Update MPI Header
>   mpt3sas: Add nvme device support in slave alloc, target alloc and
>     probe
>   mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
>   mpt3sas: Added support for nvme encapsulated request message.
>   mpt3sas: API 's to support NVMe drive addition to SML
>   mpt3sas: API's to remove nvme drive from sml
>   mpt3sas: Handle NVMe PCIe device related events generated
>        from firmware.
>   mpt3sas: Set NVMe device queue depth as 128
>   mpt3sas: scan and add nvme device after controller reset
>   mpt3as: Add-Task-management-debug-info-for-NVMe-drives.
>   mpt3sas: NVMe drive support for BTDHMAPPING ioctl command and log
>     info
>   mpt3sas: Fix nvme drives checking for tlr.
>   mpt3sas: Update mpt3sas driver version.
>
>  drivers/scsi/mpt3sas/mpi/mpi2.h          |   43 +-
>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  647 ++++++++++-
>  drivers/scsi/mpt3sas/mpi/mpi2_init.h     |   11 +-
>  drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |  331 ++++++-
>  drivers/scsi/mpt3sas/mpi/mpi2_pci.h      |  142 +++
>  drivers/scsi/mpt3sas/mpi/mpi2_tool.h     |   14 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c      |  710 +++++++++++-
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  171 +++-
>  drivers/scsi/mpt3sas/mpt3sas_config.c    |  100 ++
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  158 ++-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 1874 ++++++++++++++++++++++++++++--
>  drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |    2 +-
>  12 files changed, 4063 insertions(+), 140 deletions(-)
>  create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_pci.h
>
> Thanks,
> Suganath Prabu S
