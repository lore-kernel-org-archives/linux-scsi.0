From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Mon, 17 Oct 2005 11:43:12 +0100
Message-ID: <20051017104312.GB22710@infradead.org>
References: <20051015013824.GA25248@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10417 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932261AbVJQKnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:43:13 -0400
Content-Disposition: inline
In-Reply-To: <20051015013824.GA25248@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Sat, Oct 15, 2005 at 02:38:24AM +0100, Ralf Baechle wrote:
> FYI and reviewing pleassure.

NACK, no more new procfs support for scsi driver.

The sgiwd93.h removal is fine, but please also mark all functions that
were in it previously static.

