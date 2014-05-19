From: Christoph Hellwig <hch@infradead.org>
Subject: Re: tgt infrastructure removal
Date: Mon, 19 May 2014 07:09:33 -0700
Message-ID: <20140519140933.GA14641@infradead.org>
References: <1397557614-21243-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaESOJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 10:09:36 -0400
Content-Disposition: inline
In-Reply-To: <1397557614-21243-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

Any comments on this series?

The last time the subject came up in
http://marc.info/?t=139056945300005&r=1&w=2 Tomo said:

"I'm not sure there are any users of the driver. I guess that
you could try to remove the driver to see if someone would complain."

and Hannes brought up a mysteria out of tree user in SLES that so far
hasn't complained.

