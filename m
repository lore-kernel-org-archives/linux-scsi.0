From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 10:50:01 -0500
Message-ID: <1147881002.3463.23.camel@mulgrave.il.steeleye.com>
References: <4468B596.9090508@garzik.org>
	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
	 <4469F2B2.703@garzik.org>
	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
	 <4469F9FB.7020807@garzik.org>
	 <1147797507.3505.52.camel@mulgrave.il.steeleye.com>
	 <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de>
	 <446B3BE0.8040806@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:44255 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750732AbWEQPuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 11:50:13 -0400
In-Reply-To: <446B3BE0.8040806@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

On Wed, 2006-05-17 at 11:06 -0400, Jeff Garzik wrote:
> storage device and storage host are key objects included in the 

This is one of the questions.  Currently block has no concept of "host".
All it knows about are queues (which may be per host or per device
depending on the implementation).  Do we need to introduce the concept
of something like queue grouping (a sort of lightweight infrastructure
that could be used by the underlying transport to implement a host
concept without introducing hosts at the block layer)?

James


