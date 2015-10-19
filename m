From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/25] HiSilicon SAS driver
Date: Mon, 19 Oct 2015 09:47:41 +0100
Message-ID: <5624AE2D.9070200@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

Could we please get a review for our driver? We have got some good input 
on changes we need to make, and we will produce another patchset in the 
coming days. However it would good to get a subsystem maintainer 
review/acknowledgement to progress our upstreaming.

Thanks in advance,
John

On 12/10/2015 16:20, John Garry wrote:
> This is the driver patchset for the HiSilicon SAS driver. The driver
> is a platform driver.
>
> The driver will support multiple revisions of HW. Currently only "v1"
> HW is supported.
>
> The driver uses libsas framework within the SCSI framework.
>
> The v1 HW supports SSP and SMP, but not STP/SATA.
>
>
> John Garry (25):
>    [SCSI] sas: centralise ssp frame information units
>    devicetree: bindings: scsi: HiSi SAS
>    scsi: hisi_sas: add initial bare driver
>    scsi: hisi_sas: add scsi host registration
>    scsi: hisi_sas: allocate memories and create pools
>    scsi: hisi_sas: add slot init code
>    scsi: hisi_sas: add ioremap for device HW
>    scsi: hisi_sas: add cq structure initialization
>    scsi: hisi_sas: add phy SAS ADDR initialization
>    scsi: hisi_sas: add misc HBA initialization
>    scsi: hisi_sas: add v1 hardware register definitions
>    scsi: hisi_sas: add v1 HW initialisation code
>    scsi: hisi_sas: add path from phyup irq to SAS framework
>    scsi: hisi_sas: add ssp command function
>    scsi: hisi_sas: add cq interrupt handler
>    scsi: hisi_sas: add dev_found and port_formed
>    scsi: hisi_sas: add abnormal irq handler
>    scsi: hisi_sas: add dev_gone and port_deformed
>    scsi: hisi_sas: add bcast interrupt handler
>    scsi: hisi_sas: add smp protocol support
>    scsi: hisi_sas: add scan finished and start
>    scsi: hisi_sas: add tmf methods
>    scsi: hisi_sas: add control phy handler
>    scsi: hisi_sas: add fatal irq handler
>    MAINTAINERS: add maintainer for HiSi SAS driver
>
>   .../devicetree/bindings/scsi/hisilicon-sas.txt     |   63 +
>   MAINTAINERS                                        |    7 +
>   drivers/scsi/Kconfig                               |    1 +
>   drivers/scsi/Makefile                              |    1 +
>   drivers/scsi/aic94xx/aic94xx_sas.h                 |   49 +-
>   drivers/scsi/hisi_sas/Kconfig                      |    5 +
>   drivers/scsi/hisi_sas/Makefile                     |    2 +
>   drivers/scsi/hisi_sas/hisi_sas.h                   |  406 +++++
>   drivers/scsi/hisi_sas/hisi_sas_init.c              |  489 ++++++
>   drivers/scsi/hisi_sas/hisi_sas_main.c              | 1115 ++++++++++++
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             | 1850 ++++++++++++++++++++
>   include/scsi/sas.h                                 |   74 +
>   12 files changed, 4019 insertions(+), 43 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>   create mode 100644 drivers/scsi/hisi_sas/Kconfig
>   create mode 100644 drivers/scsi/hisi_sas/Makefile
>   create mode 100644 drivers/scsi/hisi_sas/hisi_sas.h
>   create mode 100644 drivers/scsi/hisi_sas/hisi_sas_init.c
>   create mode 100644 drivers/scsi/hisi_sas/hisi_sas_main.c
>   create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
