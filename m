From: Jens Axboe <axboe@suse.de>
Subject: Re: [Patch] dont block device on QUEUE_FULL for last command
Date: Tue, 5 Aug 2003 08:07:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030805060745.GU854@suse.de>
References: <OF122C5E1B.D9D616EB-ONC1256D78.0050C1BC@de.ibm.com> <20030804154844.GB26775@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:60136 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S272453AbTHEGHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2003 02:07:49 -0400
Content-Disposition: inline
In-Reply-To: <20030804154844.GB26775@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andreas Herrmann <AHERRMAN@de.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Aug 04 2003, Jeff Garzik wrote:
> For most cases you _should_ block until another command is completed, at
> the very least.  Retrying the command immediately is _exactly_ the
> situation one wishes to avoid, when returning a QUEUE_FULL result!

Depends very much on who you ask :-)

-- 
Jens Axboe

