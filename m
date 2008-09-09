From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/8] sg cleanup patches after the block conversion
Date: Tue, 9 Sep 2008 15:42:35 +0200
Message-ID: <20080909134235.GN20055@kernel.dk>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080909223555K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:55317 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYIINmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2008 09:42:39 -0400
Content-Disposition: inline
In-Reply-To: <20080909223555K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Tue, Sep 09 2008, FUJITA Tomonori wrote:
> On Tue,  2 Sep 2008 22:50:00 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > Here's some cleanup patches, removing functions that became
> > unnecessary after the block conversion, functions used temporally
> > during the conversion, etc.
> > 
> > This is against the for-2.6.28 brach in the block tree:
> 
> Jens, can you apply this to your for-2.6.28?

Certainly, I thought I already had...

-- 
Jens Axboe

