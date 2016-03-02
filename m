From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 12/34] cxgb4: update Kconfig and Makefile
Date: Wed, 2 Mar 2016 16:26:27 +0530
Message-ID: <20160302105625.GB1781@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <3047de46b89ddbe92b6125f773e8149bde59f8a1.1455467089.git.varun@chelsio.com>
 <20160301144706.GA9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160301144706.GA9738@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "roland@kernel.org" <roland@kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 01, 2016 at 08:17:06PM +0530, Christoph Hellwig wrote:
> > +config CHELSIO_T4_UWIRE
> > +	bool "Unified Wire Support for Chelsio T5 cards"
> > +	default n
> > +	depends on CHELSIO_T4
> > +	---help---
> > +	  Enable unified-wire offload features.
> > +	  Say Y here if you want to enable unified-wire over Ethernet
> > +	  in the driver.
> 
> And what the hell is "unified-wire over Ethernet".  A little more
> explanation would be very helpful for the user facing this question.

Ok, I will update the help in v2 series.
