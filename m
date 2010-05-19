From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET] block,libata: implement ->unlock_native_capacity()
Date: Wed, 19 May 2010 09:08:35 +0200
Message-ID: <20100519070835.GG25951@kernel.dk>
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <4BF38DC4.3090900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56634 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0ESHIh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2010 03:08:37 -0400
Content-Disposition: inline
In-Reply-To: <4BF38DC4.3090900@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net, bzolnier@gmail.com

On Wed, May 19 2010, Tejun Heo wrote:
> On 05/15/2010 08:09 PM, Tejun Heo wrote:
> > Hello, all.
> > 
> > This is the evolved version of the implement-set_capacity patchset[L]
> > and contains the following patches.
> > 
> >  0001-buffer-make-invalidate_bdev-drain-all-percpu-LRU-add.patch
> >  0002-block-restart-partition-scan-after-resizing-a-device.patch
> >  0003-block-ide-simplify-bdops-set_capacity-to-unlock_nati.patch
> >  0004-block-use-struct-parsed_partitions-state-universally.patch
> >  0005-block-improve-automatic-native-capacity-unlocking.patch
> >  0006-SCSI-implement-sd_unlock_native_capacity.patch
> >  0007-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
> >  0008-libata-implement-on-demand-HPA-unlocking.patch
> 
> Other than block part, everything is acked, so how do we route this?
> 0001-0005 through block tree and 0006-0008 through libata tree seem
> the easiest unless someone objects.  Jens, can you please review
> 0001-0005 and take them into block tree if it seems okay?

Yeah will do.

-- 
Jens Axboe

