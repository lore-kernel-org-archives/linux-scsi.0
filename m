From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: LLDD: scatterlists only?
Date: Sun, 14 Aug 2005 18:51:00 -0500
Message-ID: <1124063460.18802.27.camel@mulgrave>
References: <20050814232446.58676.qmail@web51604.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61380 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932359AbVHNXvO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 19:51:14 -0400
In-Reply-To: <20050814232446.58676.qmail@web51604.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2005-08-14 at 16:24 -0700, Luben Tuikov wrote:
> Did someone have a patch or was there a talk
> that SCSI Core is moving towards sending _only_ scatterlists
> down to LLDDs?  (effectively BUG_ON(!cmd->use_sg))

Yes, you can already see the beginnings in the -mm tree.

Jens is maintaining a block tree with this in here:

http://www.kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=shortlog;h=rq-map

And I have a scsi-block-2.6 tree based off this here:

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-block-2.6.git;a=summary

The missing (and frankly really nasty) pieces are pulling all the sg
handling out of sg and st, but fortunately Mike Christie is working on
that.

James


