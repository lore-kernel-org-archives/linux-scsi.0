From: Christoph Hellwig <hch@infradead.org>
Subject: Re: status of drivers/scsi/scsi_tgt_lib.c
Date: Thu, 30 Jan 2014 00:44:44 -0800
Message-ID: <20140130084444.GA27169@infradead.org>
References: <20140124131525.GA30922@infradead.org>
 <20140125.124832.1568838937885770665.fujita.tomonori@lab.ntt.co.jp>
 <20140127075038.GA18590@infradead.org>
 <20140128.004504.1305564732068179852.fujita.tomonori@lab.ntt.co.jp>
 <52E79B6C.3090809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaA3Ioz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jan 2014 03:44:55 -0500
Content-Disposition: inline
In-Reply-To: <52E79B6C.3090809@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Jan 28, 2014 at 12:58:36PM +0100, Hannes Reinecke wrote:
> I actually know of a customer using this (with a semi-proprietary
> target mode driver). I'll be asking him what his plans are.

They are using the IBM pseries vscsi driver for that?  It they actually
adding out of tree kernel code it doesn't really matter at all for this
discussion..

