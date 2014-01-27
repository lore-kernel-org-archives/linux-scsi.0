From: Christoph Hellwig <hch@infradead.org>
Subject: Re: status of drivers/scsi/scsi_tgt_lib.c
Date: Sun, 26 Jan 2014 23:50:38 -0800
Message-ID: <20140127075038.GA18590@infradead.org>
References: <20140124131525.GA30922@infradead.org>
 <20140125.124832.1568838937885770665.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaA0Huk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2014 02:50:40 -0500
Content-Disposition: inline
In-Reply-To: <20140125.124832.1568838937885770665.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sat, Jan 25, 2014 at 12:48:32PM +0900, FUJITA Tomonori wrote:
> Hey,
> 
> On Fri, 24 Jan 2014 05:15:25 -0800
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Do you know if either SRP or ibmvscsi are used regularly these days?
> > Does tgtd userspace still support this interface?
> 
> It doesn't. I think that ibm pseries switched to virtual fc driver
> from virtual srp long ago. Only very old pseries could use the
> driver. I'm not sure there are any users of the driver. I guess that
> you could try to remove the driver to see if someone would complain.

Should we try to throw in a deprecation warnings for this merge window
and see if anyone cares, or go ahead and remove it entirely?
