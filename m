From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Allow SCSI hosts to be less verbose
Date: Tue, 22 Sep 2009 09:09:39 -0400
Message-ID: <20090922130939.GA21265@infradead.org>
References: <20090920225348.GB3690@parisc-linux.org> <20090920225639.GD3690@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbZIVNJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2009 09:09:35 -0400
Content-Disposition: inline
In-Reply-To: <20090920225639.GD3690@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Sun, Sep 20, 2009 at 04:56:39PM -0600, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> Introduce a 'quiet' flag in the scsi_host_template which drivers can
> set to prevent (in the first instance) printing their name when they
> register with the SCSI core.  Set the quiet flag in the USB Storage
> driver.

Seems weird to make this conditional.  I'd vote for removing it
completely.

