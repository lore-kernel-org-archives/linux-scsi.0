From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix for Incorrect number of segments after building list problem
Date: Wed, 20 Oct 2004 16:39:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020143940.GK10531@suse.de>
References: <1097790683.1717.47.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:20097 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S268325AbUJTOkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 10:40:18 -0400
Content-Disposition: inline
In-Reply-To: <1097790683.1717.47.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 14 2004, James Bottomley wrote:
> This is a rather nasty hack at the momen, but it seems to persuade
> blk_recalc_rq_segments() not to underestimate.
> 
> Could you try it in your setup to see if it fixes the problem?

Strange how this survived so long, thanks for debugging this James. The
patch does look a little hackish, I'll see if I can beat it into
submission.

-- 
Jens Axboe

