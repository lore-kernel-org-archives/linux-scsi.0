From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/20] target: Remove direct ramdisk code
Date: Fri, 8 Jul 2011 15:59:14 -0400
Message-ID: <20110708195914.GC12288@infradead.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
 <1310078011-15504-6-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:32868
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab1GHT7P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 15:59:15 -0400
Content-Disposition: inline
In-Reply-To: <1310078011-15504-6-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jul 07, 2011 at 03:33:16PM -0700, Andy Grover wrote:
> Instead of converting rd_dr to be se_mem-free, just remove it.
> 
> This also lets us remove hooks like do_se_mem_map, that are in the common
> path but only implemented by rd_dr.

Looks fine.  It's a lot of ugly code to save a single memcpy.

