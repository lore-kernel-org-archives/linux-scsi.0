From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: scsi_cmnd accessors issues
Date: Sat, 16 Jun 2007 10:45:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0706161042270.5144@poirot.grange>
References: <466EDFAC.9020104@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45472 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751776AbXFPIpg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jun 2007 04:45:36 -0400
In-Reply-To: <466EDFAC.9020104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>

Hi

On Tue, 12 Jun 2007, Boaz Harrosh wrote:

> I get compilation errors. Attached solution is to add scsi_set_ 
> accessors to these members. But it would be best to STOP these drivers 
> from doing that ugly hack of modifying sg_count and bufflen.
> (CC sign-off-by maintainers of the drivers in question. Files are
> drivers/scsi/tmscsim.c & drivers/scsi/stex.c )

Thanks for the patch. I think, getting rid of the SavedSGCount field is a 
bit more complicated (would be better if you had sent the patch inline). 
I'm currently working on a solution, please, give me some time.

Thanks
Guennadi
---
Guennadi Liakhovetski
