From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] st: set owner in struct device_driver
Date: Wed, 12 Nov 2014 02:31:20 -0800
Message-ID: <20141112103120.GA19140@infradead.org>
References: <DDB9C85B850785449757F9914A034FCB3BEF2A93@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKLKbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 05:31:22 -0500
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BEF2A93@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>

Looks good to me.  Can you also send the equivalent patch for the osst
and ch drivers?
