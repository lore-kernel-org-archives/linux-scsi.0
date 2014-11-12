From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] st: set owner in struct device_driver
Date: Wed, 12 Nov 2014 09:25:01 -0800
Message-ID: <20141112172501.GA18862@infradead.org>
References: <DDB9C85B850785449757F9914A034FCB3BEF2A93@G9W0766.americas.hpqcorp.net>
 <20141112103120.GA19140@infradead.org>
 <DDB9C85B850785449757F9914A034FCB3BEF2CDA@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaKLRZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 12:25:03 -0500
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BEF2CDA@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>

On Wed, Nov 12, 2014 at 12:01:31PM +0000, Seymour, Shane M wrote:
> I can, but at this point it will be tomorrow (11pm where I am).

Looks like none of th scsi_driver intances sets the owner field.  Let me
sort this out in a generic way, and thanks for the initial patch!

