From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] hpsa: add missing pci_set_master in kdump path
Date: Wed, 24 Sep 2014 07:04:04 -0700
Message-ID: <20140924140404.GA4130@infradead.org>
References: <5412EA9F.4060703@redhat.com>
 <54229D86.4050205@redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402958C9A0AF@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaIXOEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 10:04:06 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C9A0AF@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Scales, Webb" <webb.scales@hp.com>, "Handzik, Joe" <joseph.t.handzik@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>

On Wed, Sep 24, 2014 at 01:59:04PM +0000, Elliott, Robert (Server Storage) wrote:
> Sorry for the delay - that is fine to go in directly, or will be part
> of a larger hpsa series if HP or PMC is able to post one for 3.18.

Thanks.  For a fix like this I'd prefer to take it ASAP instead of
waiting for a series, specially near the end of the merge window.
