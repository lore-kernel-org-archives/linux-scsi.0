From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: separate bsg and SCSI (so SCSI can be modular)
Date: Thu, 19 Jul 2007 19:31:34 +0200
Message-ID: <20070719173134.GY11657@kernel.dk>
References: <1184858110.3464.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:4258 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937069AbXGSRbv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 13:31:51 -0400
Content-Disposition: inline
In-Reply-To: <1184858110.3464.92.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Jul 19 2007, James Bottomley wrote:
> This patch moves the bsg registration into SCSI so that bsg no longer
> has a dependency on the scsi_interface_register API.
> 
> This can be viewed as a temporary expedient until we can get universal
> bsg binding sorted out properly.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

