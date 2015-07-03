From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 1/2] cxlflash: Base superpipe support
Date: Fri, 03 Jul 2015 13:47:01 +1000
Message-ID: <1435895221.15310.7.camel@neuling.org>
References: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <1435820412.28784.45.camel@neuling.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:41609 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbbGCDrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2015 23:47:04 -0400
In-Reply-To: <1435820412.28784.45.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Thu, 2015-07-02 at 17:00 +1000, Michael Neuling wrote:
> > +struct dk_cxlflash_attach {
> > +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> > +	__u64 num_interrupts;		/* Requested number of interrupts */
> > +	__u64 context_id;		/* Returned context */
> 
> Matt,
> 
> These ioctls seem to take a context id.  Why isn't that assumed from the
> fd?  Why get it again from userspace?

Sorry, ignore this.  I'm thinking about the wrong file descriptor.

Mikey
