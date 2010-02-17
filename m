From: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: RE: [PATCH] MVSAS: hot plug handling and IO issues
Date: Wed, 17 Feb 2010 18:23:58 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF71F646C228@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
    <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se>
 <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:38679 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0BQMyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 07:54:09 -0500
In-Reply-To: <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>, Mikael Abrahamsson <swmike@swm.pp.se>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>

Hi Smit,

This patch is not exactly replaced with Nov-09 patches. 
My patch addresses the RAID5/6 issues also. Below issues are addressed by my patch. 
1. Tape issues. 
2. RAID-5/6 I/O fails. 
3. LVM IO fails and subsequent init 6 hang (connect SAS+SATA in cascaded 	expanders, crate volume group and logical volumes, run file I/O    	(alltest), unplug one drive)
4. Disk stress I/O on 4096 sector size. 
5. Hot insertion of drives giving panic. 
6. 'fdisk -l' hangs with hot plugging of SATA/SAS drives in expander while 	IO (Diskstress and alltest) is going on and IO stopped. 

I can't combined my patch with November-09 patches. James also rejected those patches as those are not proper. Let me know if you have issues with my patch. 

--Srini.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Caspar Smit
Sent: Tuesday, February 16, 2010 8:11 PM
To: Mikael Abrahamsson
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues

So this patch replaces the november '09 patches?

( [PATCH 7/7]MVSAS: Compatible with the new libsas )
[PATCH 6/7]MVSAS: Enhanced hot plug handling
[PATCH 5/7]MVSAS:Optimization for DMA buffer
[PATCH 4/7]MVSAS:Make code more flexibe for different chip model.
[PATCH 3/7]MVSAS: bug fix with big endian
[PATCH 2/7]MVSAS:add supporting MSI feature
[PATCH 1/7]MVSAS: Update chip initialization

Those patches fixed the raid5/6 initialization issue were disks were
dropped during the creation of a raid set.
Is that fixed in this patch too?

Kind regards,
Caspar Smit

> On Tue, 16 Feb 2010, Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL
> Tech wrote:
>
>> From: Srinivas <satyasrinivasp@hcl.in>
>> Date: Mon, 15 Feb 2010
>> Subject: [PATCH]: Fix for hot plug handling and IO issues.
>> 	Added code for handling of hot-plugging drives and tape issues.
>>
>> Signed-off-by: Srinivas <satyasrinivasp@hcl.in>
>
> Tested-by: Mikael Abrahamsson <swmike@swm.pp.se>
>
> (If this tag is valid, couldn't really confirm).
>
> Anyhow, this patch is a huge step up from the stock 2.6.32 kernel, so I'd
> like to see this included in the next stable rebuild.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
