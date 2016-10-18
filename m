From: Babu Moger <babu.moger@oracle.com>
Subject: Re: [PATCH] scsi: update rdac devices at scsi_dh_rdac
Date: Tue, 18 Oct 2016 14:47:08 -0500
Message-ID: <39e5713e-5329-80a2-d2c5-d193f974e270@oracle.com>
References: <20161007165549.6433-1-xose.vazquez@gmail.com>
 <eb9d6973-2e0b-843b-4547-94b64dcd05fc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23250 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbcJRTr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 15:47:27 -0400
In-Reply-To: <eb9d6973-2e0b-843b-4547-94b64dcd05fc@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>

At this point, I am not the right person to ack this change. However, 
adding new vendor id's is mostly not an issue.

But, removing could be a problem. Sean has to confirm this.


On 10/18/2016 10:11 AM, Xose Vazquez Perez wrote:
> On 10/07/2016 06:55 PM, Xose Vazquez Perez wrote:
>
> This patch is pending, ACK is needed!
> The part of multipath-tools was done time ago.
>
> CC: Babu Moger, just in case.
>
>> Remove IBM/1745 ghost array.
>> There is no references nowhere, also removed from multipath-tools
>> Confirmed by the original manufacturer(NetApp), and Google shows no results.
>>
>> Replace too wide "TP9" regex with full names.
>> TP9100 is included, at it is not a RDAC array.
>> This reverts partially the commit 352047
>>
>> Add IBM 3542 and 3552, they are FAStT200 and FAStT500
>>
>> Cc: Sean Stewart <Sean.Stewart@netapp.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: SCSI ML <linux-scsi@vger.kernel.org>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>   drivers/scsi/scsi_dh.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
>> index b8d3b97..a64b5ce 100644
>> --- a/drivers/scsi/scsi_dh.c
>> +++ b/drivers/scsi/scsi_dh.c
>> @@ -49,14 +49,18 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
>>   	{"IBM", "1724",			"rdac", },
>>   	{"IBM", "1726",			"rdac", },
>>   	{"IBM", "1742",			"rdac", },
>> -	{"IBM", "1745",			"rdac", },
>>   	{"IBM", "1746",			"rdac", },
>>   	{"IBM", "1813",			"rdac", },
>>   	{"IBM", "1814",			"rdac", },
>>   	{"IBM", "1815",			"rdac", },
>>   	{"IBM", "1818",			"rdac", },
>>   	{"IBM", "3526",			"rdac", },
>> -	{"SGI", "TP9",			"rdac", },
>> +	{"IBM", "3542",			"rdac", },
>> +	{"IBM", "3552",			"rdac", },
>> +	{"SGI", "TP9300",		"rdac", },
>> +	{"SGI", "TP9400",		"rdac", },
>> +	{"SGI", "TP9500",		"rdac", },
>> +	{"SGI", "TP9700",		"rdac", },
>>   	{"SGI", "IS",			"rdac", },
>>   	{"STK", "OPENstorage D280",	"rdac", },
>>   	{"STK", "FLEXLINE 380",		"rdac", },
>>

