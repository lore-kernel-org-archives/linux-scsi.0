From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] scsi: update rdac devices at scsi_dh_rdac
Date: Sat, 22 Oct 2016 23:41:50 +0200
Message-ID: <b0fe9b75-6288-3ac5-9d77-f7f43e9a5756@gmail.com>
References: <20161007165549.6433-1-xose.vazquez@gmail.com>
 <eb9d6973-2e0b-843b-4547-94b64dcd05fc@gmail.com>
 <39e5713e-5329-80a2-d2c5-d193f974e270@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36786 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755759AbcJVVlx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2016 17:41:53 -0400
Received: by mail-wm0-f66.google.com with SMTP id f193so3965543wmg.3
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2016 14:41:53 -0700 (PDT)
In-Reply-To: <39e5713e-5329-80a2-d2c5-d193f974e270@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Babu Moger <babu.moger@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>

On 10/18/2016 09:47 PM, Babu Moger wrote:

> At this point, I am not the right person to ack this change.

Thank you anyway.

Last chance before this patch is lost in the mailing list noise.

> However, adding new vendor id's is mostly not an issue.

> But, removing could be a problem. Sean has to confirm this.

It already was done, all changes are already included in
multipath-tools. See below.

> On 10/18/2016 10:11 AM, Xose Vazquez Perez wrote:
>> On 10/07/2016 06:55 PM, Xose Vazquez Perez wrote:
>>
>> This patch is pending, ACK is needed!
>> The part of multipath-tools was done time ago.
>>
>> CC: Babu Moger, just in case.

>>> Remove IBM/1745 ghost array.
>>> There is no references nowhere, also removed from multipath-tools
>>> Confirmed by the original manufacturer(NetApp), and Google shows no results.

http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commitdiff;h=ae9c385ab793600c3595c1ee513463d8d4ccf885

>>> Replace too wide "TP9" regex with full names.
>>> TP9100 is included, at it is not a RDAC array.
>>> This reverts partially the commit 352047

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=352047
http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commitdiff;h=c6fbd3725c06b3ee240ce0fe4e5eedb97f934e09

>>> Add IBM 3542 and 3552, they are FAStT200 and FAStT500

http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commitdiff;h=4080b06683f8045a331631a0b8cb12be2becd0cf
http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commitdiff;h=e39610b0d3a4b5da16adcd10f18460dde609c41b

>>> Cc: Sean Stewart <Sean.Stewart@netapp.com>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>>> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>>> Cc: SCSI ML <linux-scsi@vger.kernel.org>
>>> Cc: device-mapper development <dm-devel@redhat.com>
>>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>> ---
>>>   drivers/scsi/scsi_dh.c | 8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
>>> index b8d3b97..a64b5ce 100644
>>> --- a/drivers/scsi/scsi_dh.c
>>> +++ b/drivers/scsi/scsi_dh.c
>>> @@ -49,14 +49,18 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
>>>       {"IBM", "1724",            "rdac", },
>>>       {"IBM", "1726",            "rdac", },
>>>       {"IBM", "1742",            "rdac", },
>>> -    {"IBM", "1745",            "rdac", },
>>>       {"IBM", "1746",            "rdac", },
>>>       {"IBM", "1813",            "rdac", },
>>>       {"IBM", "1814",            "rdac", },
>>>       {"IBM", "1815",            "rdac", },
>>>       {"IBM", "1818",            "rdac", },
>>>       {"IBM", "3526",            "rdac", },
>>> -    {"SGI", "TP9",            "rdac", },
>>> +    {"IBM", "3542",            "rdac", },
>>> +    {"IBM", "3552",            "rdac", },
>>> +    {"SGI", "TP9300",        "rdac", },
>>> +    {"SGI", "TP9400",        "rdac", },
>>> +    {"SGI", "TP9500",        "rdac", },
>>> +    {"SGI", "TP9700",        "rdac", },
>>>       {"SGI", "IS",            "rdac", },
>>>       {"STK", "OPENstorage D280",    "rdac", },
>>>       {"STK", "FLEXLINE 380",        "rdac", },
>>>
> 
> 

