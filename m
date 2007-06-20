From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH v2] fix request->cmd == INT cases
Date: Wed, 20 Jun 2007 13:59:18 +0200
Message-ID: <20070620115918.GT18863@kernel.dk>
References: <4679133B.9080604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:8882 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbXFTL76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jun 2007 07:59:58 -0400
Content-Disposition: inline
In-Reply-To: <4679133B.9080604@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jun 20 2007, Boaz Harrosh wrote:
> 
>  - I have unearthed very old bugs in stale drivers that still
>    used request->cmd as a READ|WRITE int
>  - This patch is maybe a proof that these drivers have not been
>    used for a long time. Should they be removed completely?

Applies fine now, thanks!

-- 
Jens Axboe

