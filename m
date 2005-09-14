From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Wed, 14 Sep 2005 11:37:12 +0100
Message-ID: <20050914103712.GA30503@infradead.org>
References: <1126308949.4799.54.camel@mulgrave> <20050910041218.29183.qmail@web51612.mail.yahoo.com> <20050911093847.GA5429@infradead.org> <4325FA6F.3060102@adaptec.com> <20050913154014.GE32395@parisc-linux.org> <1126677387.26050.71.camel@sipan.sipan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:14481 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932707AbVINKhW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 06:37:22 -0400
Content-Disposition: inline
In-Reply-To: <1126677387.26050.71.camel@sipan.sipan.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Panov <sipan@sipan.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@infradead.org>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Sep 14, 2005 at 01:56:27AM -0400, Sergey Panov wrote:
> > As you know, stuff is being rearranged to move more of the SPI-specific
> > code from both SCSI core and LLDDs into the SPI transport.  I suspect
> > domain discovery will always be triggered by the LLDD for SPI, but at
> > least a driver doesn't have to have its own code to do that any more.
> 
> Only if it can be turned into a some sort of library LLDD may use if it
> needs it. But it is only makes sense to move that code out of the LLDD
> and into the transport module, if more then one LLDD can make use of it.

Umm, that's exactly what we are doing.

