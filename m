From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND 4/5] ipr: Set scsi_level correctly for disk	arrays
Date: Mon, 15 Dec 2014 05:46:32 -0800
Message-ID: <20141215134632.GB32556@infradead.org>
References: <201412021847.sB2IlkT5007118@d03av01.boulder.ibm.com>
 <20141204092539.GA24151@lst.de>
 <54808789.50403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLONqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 08:46:35 -0500
Content-Disposition: inline
In-Reply-To: <54808789.50403@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, anton@samba.org

On Thu, Dec 04, 2014 at 10:10:49AM -0600, Brian King wrote:
> On 12/04/2014 03:25 AM, Christoph Hellwig wrote:
> > Do you want me to apply this patch ASAP while waiting for the kexec ACK?
> 
> Both patches 1 and 4 can be pulled in while we wait for Eric's ack.

I've applied patches 1 and 4 to drivers-for-3.19.
