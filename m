From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v4 0/6] ata port runtime power management support
Date: Thu, 01 Dec 2011 09:20:05 -0500
Message-ID: <4ED78D15.1000306@pobox.com>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com> <CAF1ivSa8d-VNbOmO9UyG-J3TKDmfuuX9pWEtT_7a7OcCC-0Uow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSa8d-VNbOmO9UyG-J3TKDmfuuX9pWEtT_7a7OcCC-0Uow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 12/01/2011 09:09 AM, Lin Ming wrote:
> On Mon, Nov 28, 2011 at 9:15 AM, Lin Ming<ming.m.lin@intel.com>  wrote:
>> Hi all,
>>
>> This is the v4 patches to add ata port runtime pm support.
>> Applied on top of v3.2-rc2.
>>
>> Jeff, any comment on the ata patches?
>> James, any comment on the scsi patches?
>
> Ping ...
>
> Which git tree should these patches go into? ATA or SCSI?
>
> Lin Ming (6):
>      ata: make ata port as parent device of scsi host
>      [SCSI] add flag to skip the runtime PM calls on the host
>      [SCSI] check runtime PM status in system PM
>      [SCSI] sd: check runtime PM status in sd_shutdown
>      ata: add ata port system PM callbacks
>      ata: add ata port runtime PM callbacks
>
>   drivers/ata/libata-core.c      |  154 ++++++++++++++++++++++------------------
>   drivers/ata/libata-scsi.c      |    3 +-
>   drivers/ata/libata-transport.c |    5 ++
>   drivers/ata/libata.h           |    1 +
>   drivers/scsi/scsi_error.c      |    5 +-
>   drivers/scsi/scsi_pm.c         |   16 ++++-
>   drivers/scsi/sd.c              |    5 ++
>   include/scsi/scsi_host.h       |    3 +
>   8 files changed, 118 insertions(+), 74 deletions(-)

I think ATA, with SCSI acks...

	Jeff
