From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] gdth: Split out EISA and ISA register code
Date: Sat, 21 Jul 2007 12:00:30 +0100
Message-ID: <20070721110030.GA22627@infradead.org>
References: <20070721022032.GA7264@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41423 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285AbXGULAd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jul 2007 07:00:33 -0400
Content-Disposition: inline
In-Reply-To: <20070721022032.GA7264@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

On Fri, Jul 20, 2007 at 10:20:32PM -0400, Jeff Garzik wrote:
> 
> No code changes, only indentation and blank line additions, plus code to
> call the new split-out functions.

I have patches that do this and do a few things better (e.g. proper CONFIG_ISA
ifdefs instead of the ia64 hacks).  I'll send it out in a minute.

