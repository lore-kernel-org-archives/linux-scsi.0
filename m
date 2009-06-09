From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/8] cciss: Use schedule_timeout_uninterruptible in
	SCSI error handling code
Date: Tue, 9 Jun 2009 05:48:06 +0200
Message-ID: <20090609034805.GV11363@kernel.dk>
References: <20090608205938.GG23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:59667 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZFIDsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 23:48:04 -0400
Content-Disposition: inline
In-Reply-To: <20090608205938.GG23523@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, mikem@beardog.cca.cpqcorp.net

On Mon, Jun 08 2009, scameron@beardog.cca.cpqcorp.net wrote:
> 
> 
> Use schedule_timeout_uninterruptible instead of schedule_timeout in the
> scsi error handling code when waiting between TUR polls since we are not
> interested in nor want to be interrupted by signals.

Thanks Steve, applied 1-8.

-- 
Jens Axboe

