From: David <spoel@xray.bmc.uu.se>
Subject: Re: [Rocks-Discuss]Huge 1.2TB partition
Date: Fri, 24 Sep 2004 18:04:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096041868.5202.0.camel@h153n2fls34o1123.telia.com>
References: <1096019417.2726.61.camel@whirl.lab7.lan>
	 <41544111.4080903@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from av9-2-sn1.fre.skanova.net ([81.228.11.116]:6309 "EHLO
	av9-2-sn1.fre.skanova.net") by vger.kernel.org with ESMTP
	id S268877AbUIXQD1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 12:03:27 -0400
In-Reply-To: <41544111.4080903@scalableinformatics.com>
List-Id: linux-scsi@vger.kernel.org
To: Joe Landman <landman@scalableinformatics.com>
Cc: stas@itam.nsc.ru, Linux-scsi list <linux-scsi@vger.kernel.org>, rocks_list <npaci-rocks-discussion@sdsc.edu>

On Fri, 2004-09-24 at 17:45, Joe Landman wrote:
> Hi Stas:
> 
>   There is a bug in 2.4 kernels with SCSI  that limits you to 1 TB or 
> less.  The folks at 3ware have a patch for it (it is fixing a signed int 
> to be an unsigned int in sd.c).  Without this patch, you are going to 
> have trouble making a single large volume.  You could create 2 volumes 
> and LVM or MD them together.  This would be hard to do with the number 
> of disks you have as a RAID5.
> 
>   What is best is usually dictated by your use case.  For large storage 
> purposes, one volume might be better.
> 
The RHEL kernels are patched for this, I have two 3ware arrays with 1.2
and 1.5 Tb respectively. However RHEL has a nasty bug on these arrays as
noted before. I'd go for Fedora 2.

> Joe
> 
> Stas Nikiforov wrote:
> 
> >Hi,
> >I have RAID 5 6x250 SATA storage.
> >Is it a good idea to have one huge partition
> >or it is better to split it on smaller logical drives and then use LVM,
> >for example?
> >
> >In any way, what is a preferred filesystem for this storage?
> >I plan to use it as a mass storage for CFD results.
> >
> >Thanks in advance,
> >Stas.
> >  
> >
-- 
David.
________________________________________________________________________
David van der Spoel, PhD, Assoc. Prof., Molecular Biophysics group,
Dept. of Cell and Molecular Biology, Uppsala University.
Husargatan 3, Box 596,  	75124 Uppsala, Sweden
phone:	46 18 471 4205		fax: 46 18 511 755
spoel@xray.bmc.uu.se	spoel@gromacs.org   http://xray.bmc.uu.se/~spoel
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

