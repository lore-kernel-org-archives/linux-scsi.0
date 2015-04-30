From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: integrate scsi_dh better into the scsi core
Date: Thu, 30 Apr 2015 14:31:23 -0400
Message-ID: <20150430183123.GE30542@redhat.com>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbbD3Sdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 14:33:37 -0400
Content-Disposition: inline
In-Reply-To: <1430415151-30948-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, Apr 30 2015 at  1:32pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> This series ties scsi_dh deeper into the scsi core, and fixes all kinds
> of issues in it, most importantly the race between using and detaching
> device handlers.
> 

Yes please, thanks for doing this!

I worked around the various scan issues (due to scsi_dh mods not being
loaded before SCSI scan) by making all scsi_dh code builtin for RHEL7 --
would be nice to make the scsi_dh_handlers modules again. ;)
