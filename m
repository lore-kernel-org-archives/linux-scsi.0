From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Make SCSI SG v4 driver enabled by default and remove
	EXPERIMENTAL dependency, since udev depends on BSG.
Date: Tue, 4 Aug 2009 22:11:10 +0200
Message-ID: <20090804201110.GI12579@kernel.dk>
References: <1249403799-1725-1-git-send-email-john@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:40676 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbZHDULK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Aug 2009 16:11:10 -0400
Content-Disposition: inline
In-Reply-To: <1249403799-1725-1-git-send-email-john@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 04 2009, John Stoffel wrote:
> Make Block Layer SG support v4 the default, since recent udev versions 
> depend on this to access serial numbers and other low level info properly.
> 
> This should be backported to older kernels as well, since most distros have
> enabled this for a long time.

I've applied it, but I had to both hand-apply it (due to fuzz in the
first hunk) and fix a white space damage at the end of a line.

-- 
Jens Axboe

