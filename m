From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v4 0/6] ata port runtime power management support
Date: Thu, 1 Dec 2011 22:28:02 +0800
Message-ID: <CAF1ivSZb6dLHa_QkF10GuqHFaeuWVPAzZJCbq03La9jVB1xs-A@mail.gmail.com>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
	<CAF1ivSa8d-VNbOmO9UyG-J3TKDmfuuX9pWEtT_7a7OcCC-0Uow@mail.gmail.com>
	<4ED78D15.1000306@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63316 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1LAO2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 09:28:04 -0500
In-Reply-To: <4ED78D15.1000306@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>

On Thu, Dec 1, 2011 at 10:20 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 12/01/2011 09:09 AM, Lin Ming wrote:
>>
>> On Mon, Nov 28, 2011 at 9:15 AM, Lin Ming<ming.m.lin@intel.com> =A0w=
rote:
>>>
>>> Hi all,
>>>
>>> This is the v4 patches to add ata port runtime pm support.
>>> Applied on top of v3.2-rc2.
>>>
>>> Jeff, any comment on the ata patches?
>>> James, any comment on the scsi patches?
>>
>>
>> Ping ...
>>
>> Which git tree should these patches go into? ATA or SCSI?
>>
>> Lin Ming (6):
>> =A0 =A0 ata: make ata port as parent device of scsi host
>> =A0 =A0 [SCSI] add flag to skip the runtime PM calls on the host
>> =A0 =A0 [SCSI] check runtime PM status in system PM
>> =A0 =A0 [SCSI] sd: check runtime PM status in sd_shutdown
>> =A0 =A0 ata: add ata port system PM callbacks
>> =A0 =A0 ata: add ata port runtime PM callbacks
>>
>> =A0drivers/ata/libata-core.c =A0 =A0 =A0| =A0154
>> ++++++++++++++++++++++------------------
>> =A0drivers/ata/libata-scsi.c =A0 =A0 =A0| =A0 =A03 +-
>> =A0drivers/ata/libata-transport.c | =A0 =A05 ++
>> =A0drivers/ata/libata.h =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0drivers/scsi/scsi_error.c =A0 =A0 =A0| =A0 =A05 +-
>> =A0drivers/scsi/scsi_pm.c =A0 =A0 =A0 =A0 | =A0 16 ++++-
>> =A0drivers/scsi/sd.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A05 ++
>> =A0include/scsi/scsi_host.h =A0 =A0 =A0 | =A0 =A03 +
>> =A08 files changed, 118 insertions(+), 74 deletions(-)
>
>
> I think ATA, with SCSI acks...

OK.

Could you help to review the ATA patches?

Thanks.

>
> =A0 =A0 =A0 =A0Jeff
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
