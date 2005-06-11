From: Chris Adams <cmadams@hiwaay.net>
Subject: Re: support for old megaraid cards in megraid_mbox
Date: Fri, 10 Jun 2005 21:40:00 -0500
Message-ID: <20050611024000.GB1227461@hiwaay.net>
References: <20050610231103.GA17504@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bee.hiwaay.net ([216.180.54.11]:17809 "EHLO bee.hiwaay.net")
	by vger.kernel.org with ESMTP id S261602AbVFKCkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 22:40:17 -0400
Content-Disposition: inline
In-Reply-To: <20050610231103.GA17504@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: sreenib@lsil.com, sju@lsil.com, linux-scsi@vger.kernel.org

Once upon a time, Christoph Hellwig <hch@infradead.org> said:
> is there a technical reason the PCI_DEVICE_ID_AMI_MEGARAID and
> PCI_DEVICE_ID_AMI_MEGARAID2 cards are supported in the old
> megraid driver, but not in megaraid_mbox?  It would be a real
> pain to keep the old driver around just for those two cards.

The megaraid_mbox driver doesn't support older cards; please do not
remove the old megaraid driver until/unless there is a functional
replacement.

My understand is that the old cards communicate with the host via an
older protocol.  LSI decided that it would be easier to split the old
proto and the mbox proto into separate drivers and wrote the mbox
driver.  However, they apparently have no plans to write a driver for
the older cards (because they consider the older cards obsolete).

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
