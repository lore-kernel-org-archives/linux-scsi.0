From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 11 Nov 2003 09:40:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068572414.1815.30.camel@mulgrave>
References: <20031027153932.A16679@infradead.org>
	<018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com>
	<20031029134557.A17523@infradead.org>
	<03111117263601.01918@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:60420 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263639AbTKKRlj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 12:41:39 -0500
In-Reply-To: <03111117263601.01918@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: naveenb@cisco.com
Cc: 'Christoph Hellwig' <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Tue, 2003-11-11 at 03:56, Naveen Burmi wrote:
> During shutdown iSCSI driver gets signal to stop itself. In turn iSCSI driver 
> umounts all the partitions present of iSCSI disks, makes all the iSCSI disks 
> unavailble to the system and gracefully terminate. 
> But if iSCSI disk contains the root partition OR is part of root partition 
> then iSCSI driver must not try to umount the root partition and the iSCSI 
> disks must be available until the buffer cache gets flushed properly. For 
> this to happen iSCSI driver must be aware of all the iSCSI disk(s) that 
> constitute the root partition/devices.

I see what you're trying to do, but I don't see how this is any
different from the NFS root problem, which has already been long solved
in distribution startup systems.

James


