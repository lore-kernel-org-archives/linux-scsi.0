From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/20] cciss: fix scan_thread, sysfs stuff,
	dynamically allocate per drive structure
Date: Fri, 18 Sep 2009 22:14:02 +0200
Message-ID: <20090918201402.GP23126@kernel.dk>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:47028 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbZIRUN7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 16:13:59 -0400
Content-Disposition: inline
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com

On Thu, Sep 17 2009, Stephen M. Cameron wrote:
> The following series cleans up the broken scan_thread code,
> allows triggering of the scan_thread via sysfs, dynamically
> allocates the per device structure for each logical drive as needed
> instead of all at once at driver init time, fixes a bug in
> logical drive addressing (seen on MSA2012), and adds lunid,
> raid_level, and usage_count attributes in sysfs for each
> logical drive.

Thanks Stephen, I've queued it up. I'll look over it and comment if I
find something problematic.

-- 
Jens Axboe

