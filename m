From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v4 0/6] ata port runtime power management support
Date: Thu, 1 Dec 2011 22:09:49 +0800
Message-ID: <CAF1ivSa8d-VNbOmO9UyG-J3TKDmfuuX9pWEtT_7a7OcCC-0Uow@mail.gmail.com>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 28, 2011 at 9:15 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi all,
>
> This is the v4 patches to add ata port runtime pm support.
> Applied on top of v3.2-rc2.
>
> Jeff, any comment on the ata patches?
> James, any comment on the scsi patches?

Ping ...

Which git tree should these patches go into? ATA or SCSI?

Lin Ming (6):
    ata: make ata port as parent device of scsi host
    [SCSI] add flag to skip the runtime PM calls on the host
    [SCSI] check runtime PM status in system PM
    [SCSI] sd: check runtime PM status in sd_shutdown
    ata: add ata port system PM callbacks
    ata: add ata port runtime PM callbacks

 drivers/ata/libata-core.c      |  154 ++++++++++++++++++++++----------=
--------
 drivers/ata/libata-scsi.c      |    3 +-
 drivers/ata/libata-transport.c |    5 ++
 drivers/ata/libata.h           |    1 +
 drivers/scsi/scsi_error.c      |    5 +-
 drivers/scsi/scsi_pm.c         |   16 ++++-
 drivers/scsi/sd.c              |    5 ++
 include/scsi/scsi_host.h       |    3 +
 8 files changed, 118 insertions(+), 74 deletions(-)

Thanks,
Lin Ming

>
> v1:
> https://lkml.org/lkml/2011/11/2/23
>
> v2:
> https://lkml.org/lkml/2011/11/10/71
> Acked-by: Tejun Heo <tj@kernel.org>
> Kay Sievers reviewed sysfs change
>
> v3:
> https://lkml.org/lkml/2011/11/23/37
>
> Changes in v4:
> - check SCSI device runtime PM status in system PM (Alan Stern, Tejun=
 Heo)
>
> Changes in v3:
> - runtime resume scsi device before system suspend (Alan Stern)
> - check runtime status in sd_shutdown
>
> Thanks for any comment,
> Lin Ming
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
