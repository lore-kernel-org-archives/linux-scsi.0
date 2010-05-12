From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Wed, 12 May 2010 15:20:14 GMT
Message-ID: <201005121520.o4CFKEHx006949@demeter.kernel.org>
References: <bug-13594-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55779 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0ELPUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 11:20:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4CFKEO1006950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 12 May 2010 15:20:14 GMT
In-Reply-To: <bug-13594-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13594





--- Comment #13 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-05-12 15:20:09 ---
Reply-To: dgilbert@interlog.com

The originally reported problem has been fixed. See:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=91b25002bd58f55207e4662a611a6cded4ef9834

I was told that was scheduled to go in lk 2.6.33

Reading the bugzilla entry some of the latter posts
could be reporting some other LSI related problems.
Anyway, the bug report should be closed.

Doug Gilbert


bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=13594
> 
> 
> Ken Stailey <kstailey@yahoo.com> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |kstailey@yahoo.com
> 
> 
> 
> 
> --- Comment #12 from Ken Stailey <kstailey@yahoo.com>  2010-05-12 14:09:28 ---
> A utility from LSI is available here:
> ftp://ftp.lsil.com/HostAdapterDrivers/linux/lsiutil/ 
> 
> Some information from my use of lsutil:
> 
> Board name: LSISAS3442E-R
> Board assembly: L3-00120-05E
> 
> Current active firmware version is 01172b00 (1.23.43)
> Firmware image's version is MPTFW-01.23.43.00-IE
>   LSI Logic
> x86 BIOS image's version is MPTBIOS-6.18.05.00 (2008.05.14)
> EFI BIOS image's version is 3.05.01.01
> 
> Diagnostics -> Display phy counters:
> Adapter Phy 1: Link Up
>   Invalid DWord Count 2,734
>   Running Disparity Error Count 2,757
>   Loss of DWord Synch Count 0
>   Phy Reset Problem Count 0 
> 
> Other information:
> 
> $ lspci | grep LSI
> 03:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI-Express
> Fusion-MPT SAS (rev 08)
> 
> $ uname -srvm
> Linux 2.6.31-21-generic #59-Ubuntu SMP Wed Mar 24 07:28:27 UTC 2010 x86_64
> 
> $ strings
> /lib/modules/2.6.31-21-generic/kernel/drivers/message/fusion/mptsas.ko | grep
> version=
> version=3.04.10
> srcversion=4023EA52994688E9AE61982
> 
> $ lsb_release -d
> Description:    Ubuntu 9.10
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
