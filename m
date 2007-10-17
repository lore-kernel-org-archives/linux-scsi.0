From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add suspend/resume support for aic7xxx/aic79xx
Date: Wed, 17 Oct 2007 16:37:21 +0200
Message-ID: <20071017143721.GS5043@kernel.dk>
References: <47161877.1090000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:26245 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbXJQOhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 10:37:50 -0400
Content-Disposition: inline
In-Reply-To: <47161877.1090000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 17 2007, Hannes Reinecke wrote:
> Hi James,
> 
> due to popular demand I've clobbered together a patch for
> suspend/resume support in aic79xx/aic7xxx.
> 
> Looks reasonable enough, boots, but now I'd need someone
> to actually test it :-)
> 
> As usual, comments, results, fixes, etc. welcome.

As it so happens, I run aic7xxx on my desktop. I'll give it a spin.

-- 
Jens Axboe

