From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [LSF/MM TOPIC] Sparseness in storage
Date: Wed, 2 Feb 2011 21:23:12 -0500
Message-ID: <20110203022312.GA8529@infradead.org>
References: <4D498F4B.3050207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1BCCXN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 21:23:13 -0500
Content-Disposition: inline
In-Reply-To: <4D498F4B.3050207@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 02, 2011 at 12:07:23PM -0500, Douglas Gilbert wrote:
> are improving their sparseness handling as well, with Linux
> playing "catch up" to NTFS in this regard (e.g. the new
> FALLOC_FL_PUNCH_HOLE flag in fallocate() ).

FYI: XFS has supported hole punching for more than 15 years, although
the first years obviously were't on Linux.

