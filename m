From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 1/2] cxlflash: Base superpipe support
Date: Thu, 02 Jul 2015 17:00:12 +1000
Message-ID: <1435820412.28784.45.camel@neuling.org>
References: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:43728 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbbGBHAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2015 03:00:14 -0400
In-Reply-To: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> +struct dk_cxlflash_attach {
> +	struct dk_cxlflash_hdr hdr;	/* Common fields */
> +	__u64 num_interrupts;		/* Requested number of interrupts */
> +	__u64 context_id;		/* Returned context */

Matt,

These ioctls seem to take a context id.  Why isn't that assumed from the
fd?  Why get it again from userspace?

Mikey

