From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 4 Jan 2005 08:27:28 +0000
Message-ID: <20050104082728.GA1731@infradead.org>
References: <1104788704.5506.67.camel@mulgrave> <20050103224321.GY26051@parcelfarce.linux.theplanet.co.uk> <1104792580.5506.69.camel@mulgrave> <20050103225401.GZ26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:5256 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261555AbVADI1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 03:27:33 -0500
Content-Disposition: inline
In-Reply-To: <20050103225401.GZ26051@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, achim_leubner@adaptec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 03, 2005 at 10:54:01PM +0000, Al Viro wrote:
> ... and dma_handle *is* dma_addr_t and gets used in exact same driver to
> store the results of the same function (grep for pci_map_page in there).

But as it looks do me the driver is doing two different dma mappings in
here.

