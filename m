From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH][RELEASE] megaraid 2.10.2 Driver
Date: Tue, 23 Mar 2004 06:27:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040323062708.A29405@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E570230C77B@exa-atlanta.se.lsil.com> <20040323004543.GP25059@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:31493 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262063AbUCWG1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 01:27:23 -0500
Content-Disposition: inline
In-Reply-To: <20040323004543.GP25059@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Tue, Mar 23, 2004 at 12:45:43AM +0000
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Jeff Garzik' <jgarzik@pobox.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Mar 23, 2004 at 12:45:43AM +0000, Matthew Wilcox wrote:
> I don't think you understand how CONFIG_COMPAT works.  x86-64 defines it
> when it wants it:

But not in 2.4, and this is a 2.4-only patch..

