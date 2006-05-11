From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH/RFC] Allowing REQ_FAILFAST to be set from SG_IO
Date: Thu, 11 May 2006 12:36:36 +0200
Message-ID: <20060511103636.GJ4157@suse.de>
References: <4461EFD0.50902@suse.de> <446217D5.3020606@torque.net> <1147279812.3671.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:33121 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1030213AbWEKKgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 06:36:16 -0400
Content-Disposition: inline
In-Reply-To: <1147279812.3671.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, May 10 2006, James Bottomley wrote:
> On Wed, 2006-05-10 at 12:41 -0400, Douglas Gilbert wrote:
> > Looks good. There is no proposed change to sg.c .
> > Could SG_FLAG_FAILFAST be made to work via sg device
> > nodes?
> 
> Rather than having to maintain two separate paths for SG_IO and hence
> keep running into this issue, what will it take for sg to use the block
> scsi_ioctl.c?

The plan still remains to use bsg to consolidate the two.

-- 
Jens Axboe

