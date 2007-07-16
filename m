From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and auditing
Date: Mon, 16 Jul 2007 11:35:05 +0200
Message-ID: <20070716093505.GA19288@lst.de>
References: <4695F76F.5000305@panasas.com> <20070712135750.2a4a4a54.rdunlap@xenotime.net> <469B38CC.50501@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37126 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbXGPJfZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:35:25 -0400
Content-Disposition: inline
In-Reply-To: <469B38CC.50501@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, "J?rgen E. Fischer" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jul 16, 2007 at 12:22:20PM +0300, Boaz Harrosh wrote:
> Maybe someone can help:
> How can we cause an ->eh_device_reset_handler() call from scsi-ml?

The easiest way is a SG_SCSI_RESET ioctl on the sg device.
