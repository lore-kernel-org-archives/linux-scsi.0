From: "Caspar Smit" <c.smit@truebit.nl>
Subject: RE: ATA / mvsas issue.
Date: Thu, 1 Apr 2010 16:32:34 +0200 (CEST)
Message-ID: <1795.77.248.79.78.1270132354.squirrel@ketsers.dhs.org>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>
    <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>
    <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>
    <CDBC7B5488B245E689B39330542DC434@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:41219 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0DAOcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 10:32:43 -0400
In-Reply-To: <CDBC7B5488B245E689B39330542DC434@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org

>
>
>> Hi all,
>>
>> Today I installed 16 fresh Western Digital WD5000BEVT (2,5") drives in
>> one
>> of our test servers.
>>
>> I created a software raid5 with a hotspare on these 16 disks.
>>
>> I noticed that the detection of the disks during boottime was very very
>> slow.
>> Creating the md superblocks went very very slow.
>>
>> After that all seemed fine (speed of the raid5 init was normal).
>>
>> I noticed many of these messages in the syslog (also attached):
>>
>> Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for
>> '/dev/.tmp-8-112'
>> Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for
>> '/dev/.tmp-8-128'
>>
>> This seems to correspond to the slow detection of the disks.
>>
>> Is this an ATA problem, or a problem in the mvsas driver?
>>
>> I use the mvsas driver from 2.6.32 with the latest patch from Srinivas.
>>
>> Kind regards,
>> Caspar Smit
>>
>>
>> [Jack] It's normal behavior of SATA disk, SATA disk need more time than
>> SAS
>> disk to spin up to response command.
>
> I use loads of other SATA disks which don't have this behavior.
>
> Caspar
>
>
> [Jack] In my test, some big SATA disks(ie 500G above)have this issues.
> Best Regards

There is definatly something wrong because an:

mkfs -t xfs -f /dev/md0

takes around 15! minutes to complete.

Normally this would take 15 seconds or so.

Caspar Smit


>
> ************************************************************************
> Jack  Wang
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

