From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid updates for new proing APIs
Date: Wed, 19 Nov 2003 12:48:28 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119124828.A11769@infradead.org>
References: <20031118110110.A22400@infradead.org> <1069190962.26419.29.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:55046 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264033AbTKSMsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 07:48:32 -0500
Content-Disposition: inline
In-Reply-To: <1069190962.26419.29.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Tue, Nov 18, 2003 at 01:29:22PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Nov 18, 2003 at 01:29:22PM -0800, Mark Haverkamp wrote:
> > +	pci_set_master(pdev);
> > +	pci_set_dma_mask(pdev, 0xFFFFFFFFULL);
> 
> I've been told that the return value of this should be checked as it is
> possible for it to fail.

Indeed.  This patches objective was to convert aacraid to the new-style
probing, not to fix bugs, but I'll add the fix to the next revision of
the patch anyway.

