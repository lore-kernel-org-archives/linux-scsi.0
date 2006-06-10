From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 17:10:36 +0100
Message-ID: <20060610161036.GA21454@infradead.org>
References: <20060610160852.GA15316@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34016 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751530AbWFJQKl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:10:41 -0400
Content-Disposition: inline
In-Reply-To: <20060610160852.GA15316@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

On Sat, Jun 10, 2006 at 12:08:52PM -0400, Jeff Garzik wrote:
> 
> Please review, and queue in scsi-misc for 2.6.18 if acceptable.

The driver is not for scsi hardware.  Please implement it as block
driver.

