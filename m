From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 16 Jul 2003 10:07:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058364455.1856.28.camel@mulgrave>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net>
	<1058359278.1856.8.camel@mulgrave> <20030716124549.GX833@suse.de>
	<1058360162.1850.15.camel@mulgrave>  <20030716132036.GB833@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:20742 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270545AbTGPNw7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 09:52:59 -0400
In-Reply-To: <20030716132036.GB833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mark Haverkamp <markh@osdl.org>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-07-16 at 09:20, Jens Axboe wrote:
> blk_insert_request() is close, but it does a little more (it's useful
> another place in the scsi queueing, though). How about something like
> this? Then I can add the 'back on queue but not completed' stuff after
> that.

Looks fine well except that it needs an EXPORT_SYMBOL.  How do you want
to submit?  I'm getting close to attempting a SCSI merge, so I can send
it in with that?

James


