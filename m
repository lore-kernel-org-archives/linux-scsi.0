From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] libata-scsi: Update SATL for ZAC drives
Date: Sat, 6 Sep 2014 08:44:37 +0900
Message-ID: <20140905234437.GI15723@mtj.dyndns.org>
References: <1406706911-79510-1-git-send-email-hare@suse.de>
 <1406706911-79510-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48860 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaIEXom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 19:44:42 -0400
Content-Disposition: inline
In-Reply-To: <1406706911-79510-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Wed, Jul 30, 2014 at 09:55:10AM +0200, Hannes Reinecke wrote:
> ZAC (zoned-access command) drives translate into ZBC (Zoned block
> command) device type for SCSI. So implement the correct mappings
> into libata-scsi and update the SCSI command set versions.

Patch 2-3 look good to me.

Thanks.

-- 
tejun
