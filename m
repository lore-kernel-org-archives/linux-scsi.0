From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH  V2 0/1] Error are logged when application issues illegal
 request
Date: Fri, 26 Sep 2014 01:04:36 -0700
Message-ID: <20140926080436.GA27824@infradead.org>
References: <20140925190514.179882620@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaIZIEi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 04:04:38 -0400
Content-Disposition: inline
In-Reply-To: <20140925190514.179882620@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On Thu, Sep 25, 2014 at 02:05:14PM -0500, wenxiong@linux.vnet.ibm.com wrote:
> 
> Hi Christoph,
> 
> Sorry! This patch includes the fix in ipr.h. I built this patch in the 
> latest scsi tree.

I've insted just applied the typo fix as I didn't want to rebase.

Can you cross check:

http://git.infradead.org/users/hch/scsi-queue.git/shortlog/refs/heads/drivers-for-3.18

for me please?

