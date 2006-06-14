From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: MPT fusion driver doesn't work when compiled into kernel
Date: Wed, 14 Jun 2006 12:47:35 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701995E9@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39623 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750743AbWFNSrl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 14:47:41 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kirill Korotaev <dev@sw.ru>, linux-scsi@vger.kernel.org, Vasily Averin <vvs@sw.ru>, Andrey Mirkin <amirkin@sw.ru>

On Wednesday, June 14, 2006 1:49 AM, Kirill Korotaev wrote:
> Hello,
> 
> FYI, there is a bug in all(?) 3.x fusion drivers, which 
> prevents it from 
> working when all the fusion config options are set to 'y'.
> 
> It looks like the driver uses schedule_timeout() for delays inside, 
> which can return immediately on the boot stage and thus 
> drives are not 
> detected properly.
> 

There was a patch posted recently that changed all the interruptible
sleeps to uniterruptible sleeps.  Here is the post:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114850141621490&w=2

Pls retry test with 2.6.17-rc5 + James Bottomely's scsi-misc patch found
at
http://www.kernel.org/pub/linux/kernel/people/jejb/

Eric Moore
LSI Logic
