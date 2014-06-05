From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] mptfusion: make adapter prod_name[] a pointer
Date: Thu, 5 Jun 2014 02:31:11 -0700
Message-ID: <20140605093111.GF727@infradead.org>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
 <1401900715-19815-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaFEJbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 05:31:11 -0400
Content-Disposition: inline
In-Reply-To: <1401900715-19815-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Wed, Jun 04, 2014 at 12:51:55PM -0400, Joe Lawrence wrote:
> The struct _MPT_ADAPTER doesn't need a full copy of the product string,
> so prod_name can point to the string literal storage that the driver
> already provides.
> 
> Avoids the following sparse warning:
> 
>   drivers/message/fusion/mptbase.c:2858 MptDisplayIocCapabilities()
>     warn: this array is probably non-NULL. 'ioc->prod_name'

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
