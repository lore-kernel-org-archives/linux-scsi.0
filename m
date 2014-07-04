From: Christoph Hellwig <hch@infradead.org>
Subject: Re: tgt infrastructure removal
Date: Fri, 4 Jul 2014 02:36:43 -0700
Message-ID: <20140704093643.GA21482@infradead.org>
References: <1397557614-21243-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaGDJgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 05:36:51 -0400
Content-Disposition: inline
In-Reply-To: <1397557614-21243-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org

I got an older Ack from Tomo for the removal, and some sort of acks
for the ibmvscsi target removal from Brian, Paolo and Nathan.

Can I get some formal reviews for the code removal patches (1-4) so I
can queue this up for 3.17?

I'll have to redo patch 5 for various changes and will resend it in
time (hopefully after scsi-mq is in).

