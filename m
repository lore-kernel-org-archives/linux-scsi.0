From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: [Rocks-Discuss]Huge 1.2TB partition
Date: Fri, 24 Sep 2004 11:45:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41544111.4080903@scalableinformatics.com>
References: <1096019417.2726.61.camel@whirl.lab7.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl093-000-201.det1.dsl.speakeasy.net ([66.93.0.201]:49566 "EHLO
	crunch.scalableinformatics.com") by vger.kernel.org with ESMTP
	id S268854AbUIXPph (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 11:45:37 -0400
In-Reply-To: <1096019417.2726.61.camel@whirl.lab7.lan>
List-Id: linux-scsi@vger.kernel.org
To: stas@itam.nsc.ru
Cc: Linux-scsi list <linux-scsi@vger.kernel.org>, rocks_list <npaci-rocks-discussion@sdsc.edu>

Hi Stas:

  There is a bug in 2.4 kernels with SCSI  that limits you to 1 TB or 
less.  The folks at 3ware have a patch for it (it is fixing a signed int 
to be an unsigned int in sd.c).  Without this patch, you are going to 
have trouble making a single large volume.  You could create 2 volumes 
and LVM or MD them together.  This would be hard to do with the number 
of disks you have as a RAID5.

  What is best is usually dictated by your use case.  For large storage 
purposes, one volume might be better.

Joe

Stas Nikiforov wrote:

>Hi,
>I have RAID 5 6x250 SATA storage.
>Is it a good idea to have one huge partition
>or it is better to split it on smaller logical drives and then use LVM,
>for example?
>
>In any way, what is a preferred filesystem for this storage?
>I plan to use it as a mass storage for CFD results.
>
>Thanks in advance,
>Stas.
>  
>

-- 
Joseph Landman, Ph.D
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
phone: +1 734 612 4615

