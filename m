From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/2] scsi tgt updates (replace the elevator code)
Date: Fri, 07 Apr 2006 08:20:42 -0400
Message-ID: <1144412442.3606.1.camel@mulgrave.il.steeleye.com>
References: <20060316090410E.fujita.tomonori@lab.ntt.co.jp>
	 <4435CABD.7000200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:42645 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932434AbWDGMVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Apr 2006 08:21:06 -0400
In-Reply-To: <4435CABD.7000200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org

On Thu, 2006-04-06 at 21:13 -0500, Mike Christie wrote:
> Hey James the patchset referred to in this mail, this patchset and the 
> "[PATCH] scsi tgt: add task management function support" patch did not 
> get merged to the tgt merged. Did you want us to resend the patchsets or 
> did you not like them, or do you wnat them in one nice large patchset? 
> Or did you want us to ask Jens to merge some of the not so controversial 
> block layer stuff like "[PATCH 4/6] block layer: use blk_rq_bio_prep in 
> init_request_from_bio" first? Thanks.

Yes, just resend them to linux-scsi, thanks.  I'm going to be away for a
few days, so I'll probably get around to merging them on Wednesday or
so.

James


