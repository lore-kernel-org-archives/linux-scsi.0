From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ses: Fix wrong page error
Date: Thu, 10 Aug 2017 02:25:09 -0700
Message-ID: <20170810092509.GA6071@infradead.org>
References: <d816c664-5d28-e924-2515-b0cc7ef46498@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60350 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdHJJZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 05:25:09 -0400
Content-Disposition: inline
In-Reply-To: <d816c664-5d28-e924-2515-b0cc7ef46498@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>

On Tue, Aug 01, 2017 at 01:45:36PM -0500, Brian King wrote:
> If a SES device returns an error on a requested diagnostic page,
> we are currently printing an error indicating the wrong page
> was received. Fix this up to simply return a failure and only
> check the returned page when the diagnostic page buffer was
> populated by the device.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
