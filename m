From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sun, 3 Apr 2011 07:00:57 -0400
Message-ID: <20110403110057.GC3872@infradead.org>
References: <20110401202051.GL4183@linux.intel.com>
 <20110402133643.GB18990@infradead.org>
 <20110402210240.GD7286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1DCLA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2011 07:00:59 -0400
Content-Disposition: inline
In-Reply-To: <20110402210240.GD7286@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Sat, Apr 02, 2011 at 03:02:40PM -0600, Matthew Wilcox wrote:
> Fair enough, but you're making the perfect the enemy of the good.
> How about putting this patch in for now (since it harms nothing), and
> then it'll all go away when you delete cmd_serial_number?

If you change it anyway for mpt2sas just keep the atomic counter in
it's local structures.  Or even better verify with LSI if the
serial_number check can't simply be removed entirely, which I think it
could.

