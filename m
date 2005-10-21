From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Recover SCSI disks
Date: Fri, 21 Oct 2005 12:35:59 +0100
Message-ID: <4358D29F.1010206@robinbowes.com>
References: <dj8a8v$ta0$1@sea.gmane.org> <4358404B.9080006@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.metronet.co.uk ([213.162.97.75]:36307 "EHLO
	mail.metronet.co.uk") by vger.kernel.org with ESMTP id S964842AbVJULgZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 07:36:25 -0400
In-Reply-To: <4358404B.9080006@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert said the following on 21/10/2005 02:11:
> Robin,
> You may like to fetch sg3_utils and try sg_format thus:
>    sg_format /dev/sda
> assuming a disk you have fetched from the array is placed
> at /dev/sda .

Douglas,

THanks for the tip, I'll give it a go.

> If that fails, the disk is probably dead. Otherwise it
> should tell you several things (and doesn't change
> anything). Often drives in RAIDs are formatted
> to a sector size slightly greater than 512 bytes. To
> re-use the disk (freestanding) in linux you will need to
> format it back 512 bytes thus:
>    sg_format --format --size=512 /dev/sda
> 
> A format may not be needed. In any case, the next step
> would usually be to partition the disk (e.g. with fdisk)
> then make a file system on one or more of its partitions
> (e.g. with mkfs.ext3 ). The disk (or at least its partition)
> should then be ready to mount and use.

Thanks again,

R.
-- 
http://robinbowes.com

If a man speaks in a forest,
and his wife's not there,
is he still wrong?
