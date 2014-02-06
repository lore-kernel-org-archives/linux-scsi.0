From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into scsi_{host,target}_queue_ready
Date: Thu, 06 Feb 2014 18:10:55 +0100
Message-ID: <52F3C21F.70409@acm.org>
References: <20140205123930.150608699@bombadil.infradead.org>	 <20140205124021.286457268@bombadil.infradead.org> <1391705819.22335.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:36671 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756363AbaBFRK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 12:10:59 -0500
In-Reply-To: <1391705819.22335.8.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On 02/06/14 17:56, James Bottomley wrote:
> Could you benchmark this lot and show what the actual improvement is
> just for this series, if any?

I see a performance improvement of 12% with the SRP protocol for the
SCSI core optimizations alone (I am still busy measuring the impact of
the blk-mq conversion but I can already see that it is really
significant). Please note that the performance impact depends a lot on
the workload (number of LUNs per SCSI host e.g.) so maybe the workload I
chose is not doing justice to Christoph's work. And it's also important
to mention that with the workload I ran I was saturating the target
system CPU (a quad core Intel i5). In other words, results might be
better with a more powerful target system.

Bart.
