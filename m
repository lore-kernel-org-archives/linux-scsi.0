From: Jens Axboe <axboe@suse.de>
Subject: Re: Write cache on SATA drives?
Date: Mon, 4 Jul 2005 08:39:32 +0200
Message-ID: <20050704063932.GD1444@suse.de>
References: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com> <20050701062416.GQ2243@suse.de> <m3acl7ym7f.fsf@merlin.emma.line.org> <20050701083308.GZ2243@suse.de> <20050701084717.GA18306@merlin.emma.line.org> <20050701085412.GA2243@suse.de> <m38y0qnlt7.fsf@merlin.emma.line.org> <20050702070750.GL2243@suse.de> <m3hdfbizyj.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:23741 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261262AbVGDGh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 02:37:59 -0400
Content-Disposition: inline
In-Reply-To: <m3hdfbizyj.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: "Edwards, Scott (GE Healthcare)" <J.Scott.Edwards@ge.com>, linux-scsi@vger.kernel.org

On Sun, Jul 03 2005, Matthias Andree wrote:
> Jens Axboe <axboe@suse.de> writes:
> 
> >> Hm. Any buzz^Wkeywords to look for? "barrier" doesn't seem to be the
> >> right word, it yields only memory barriers and an as-iosched fix in
> >> 2.6.7.  I checked ChangeLog-2.6.[56789].
> >
> > Grep for blk_queue_ordered or similar in the patch.
> 
> patch-2.6.9 adds this function -- and a call to it to ide-disk.c. Have

Ah ok, 2.6.9 it is then.

> reiserfs and ext3fs supported this from the very beginning (i. e. 2.6.9)
> or is this an issue that affected only the lower layers anyhow?

They have.

-- 
Jens Axboe

