From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/7] Runtime PM support for AHCI host controller driver
Date: Thu, 18 Feb 2016 11:40:29 -0500
Message-ID: <20160218164029.GC13177@mtj.duckdns.org>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:34114 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946295AbcBRQkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2016 11:40:31 -0500
Content-Disposition: inline
In-Reply-To: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello,

Patchset looks good to me.  Once Jens acks the first patch, I'll apply
the whole series to libata/for-4.6 w/ the field initialization
updated.

Thanks.

-- 
tejun
