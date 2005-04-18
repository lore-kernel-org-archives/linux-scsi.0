From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [RFC 1 of 9] patches to add diskdump functionality to block layer
Date: Mon, 18 Apr 2005 16:40:20 -0300
Message-ID: <20050418194020.GB759@logos.cnet>
References: <D4CFB69C345C394284E4B78B876C1CF107DC050F@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7645 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261212AbVDSA1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 20:27:22 -0400
Content-Disposition: inline
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF107DC050F@cceexc23.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Apr 18, 2005 at 12:14:06PM -0500, Miller, Mike (OS Dev) wrote:
> > From: Christoph Hellwig [mailto:hch@infradead.org] 
> > 
> > This looks like a patch for Linux 2.4.  Such major changes for the
> > 2.4 tree don't make sense anymore, especially for 
> > functionality not even in Linux 2.6.
> > 
> This is for 2.4, I should have specified that in the Subject line. We
> did this work because of customer demand and a request from a vendor. 
> Marcelo, is this something that you be interested in adding to 2.4? If
> not, I'll just submit this directly to the vendor.

Mike,

Nope, that does not look suitable for v2.4.x.
