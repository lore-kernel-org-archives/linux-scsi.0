From: Stefan *St0fF* Huebner <st0ff@gmx.net>
Subject: Re: ATA / mvsas issue.
Date: Thu, 01 Apr 2010 23:05:22 +0200
Message-ID: <4BB50A92.3030205@gmx.net>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>    <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>    <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>    <CDBC7B5488B245E689B39330542DC434@usish.com.cn> <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:35069 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0DAV3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 17:29:07 -0400
In-Reply-To: <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: jack wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org

Am 01.04.2010 09:55, schrieb Caspar Smit:
>>
>>     
>>> Hi all,
>>>
>>> Today I installed 16 fresh Western Digital WD5000BEVT (2,5") drives in
>>> one
>>> of our test servers.
>>>
>>> I created a software raid5 with a hotspare on these 16 disks.
>>>
>>> I noticed that the detection of the disks during boottime was very very
>>> slow.
>>> Creating the md superblocks went very very slow.
>>>
>>> After that all seemed fine (speed of the raid5 init was normal).
>>>
>>> I noticed many of these messages in the syslog (also attached):
>>>
>>> Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for
>>> '/dev/.tmp-8-112'
>>> Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for
>>> '/dev/.tmp-8-128'
>>>
>>> This seems to correspond to the slow detection of the disks.
>>>
>>> Is this an ATA problem, or a problem in the mvsas driver?
>>>
>>> I use the mvsas driver from 2.6.32 with the latest patch from Srinivas.
>>>
>>> Kind regards,
>>> Caspar Smit
>>>
>>>
>>> [Jack] It's normal behavior of SATA disk, SATA disk need more time than
>>> SAS
>>> disk to spin up to response command.
>>>       
>> I use loads of other SATA disks which don't have this behavior.
>>
>> Caspar
>>
>>
>> [Jack] In my test, some big SATA disks(ie 500G above)have this issues.
>> Best Regards
>>     
@Jack: sorry, but that doesn't cause unresponsiveness.  Some 2TB
SATA-Disks need >10s to spin up, but there shouldn't be any notes/logs
like those.  As a matter of fact: these 2,5" drives should spin up in a
matter of 2s.
> Seagate 500G SATA disks are working fine.
>   
Hitachi also.  And I've seen WD5000BEVT work great, too.  8 of a kind in
a QNAP SS-839 (Atom based NAS with a pretty recent linux on it) work fine!

Stefan
> Caspar
>
>   
>> ************************************************************************
>> Jack  Wang
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

