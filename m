From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/1] cciss: bug fix for crash when running hpacucli
Date: Tue, 11 Apr 2006 07:39:40 +0200
Message-ID: <20060411053940.GJ3859@suse.de>
References: <20060410202541.GA28328@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:63553 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751190AbWDKFmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 01:42:37 -0400
Content-Disposition: inline
In-Reply-To: <20060410202541.GA28328@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, steve.cameron@hp.com

On Mon, Apr 10 2006, Mike Miller (OS Dev) wrote:
> PATCH 1/1
> 
> This patch fixes a crash when running hpacucli with multiple logical volumes
> on a cciss controller. We were not properly initializing the disk->queue
> and causing a fault.
> Thanks to Hasso Tepper for reporting the problem. Thanks to Steve Cameron
> for root causing the problem.
> Most of the patch just moves things around. The fix is a one-liner.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Stephen Cameron <steve.cameron@hp.com>

Thanks for nailing this one Mike! I'll add it to the upstream branch, it
should be included for 2.6.16.x as well.

-- 
Jens Axboe

