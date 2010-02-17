From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Wed, 17 Feb 2010 13:16:12 +0000
Message-ID: <73e903671002170516r6df93ea6o6e0ee256cb8f7a59@mail.gmail.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	<alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se> <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org>
	<6B62480106F2B34D8404CF2FDAA4D9EF71F646C228@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:43495 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab0BQNQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 08:16:34 -0500
Received: by fxm7 with SMTP id 7so8638723fxm.28
        for <linux-scsi@vger.kernel.org>; Wed, 17 Feb 2010 05:16:32 -0800 (PST)
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F646C228@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Feb 17, 2010 at 12:53 PM, Srinivas Naga Venkatasatya
Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
> Hi Smit,
>
> This patch is not exactly replaced with Nov-09 patches.
> My patch addresses the RAID5/6 issues also. Below issues are addresse=
d by my patch.
> 1. Tape issues.
> 2. RAID-5/6 I/O fails.
> 3. LVM IO fails and subsequent init 6 hang (connect SAS+SATA in casca=
ded =A0 =A0 =A0 =A0expanders, crate volume group and logical volumes, r=
un file I/O =A0 =A0 =A0 =A0 (alltest), unplug one drive)
> 4. Disk stress I/O on 4096 sector size.
> 5. Hot insertion of drives giving panic.
> 6. 'fdisk -l' hangs with hot plugging of SATA/SAS drives in expander =
while =A0 =A0 =A0IO (Diskstress and alltest) is going on and IO stopped=
=2E
>
> I can't combined my patch with November-09 patches. James also reject=
ed those patches as those are not proper. Let me know if you have issue=
s with my patch.
>
> --Srini.


I haven't tested yet, but looks like you're doing excellent work, and
your documentation/overview of the work is superb.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
