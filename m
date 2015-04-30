From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/9] dm-mpath, scsi_dh: request scsi_dh modules in
 scsi_dh, not dm-mpath
Date: Thu, 30 Apr 2015 14:28:53 -0400
Message-ID: <20150430182852.GD30542@redhat.com>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
 <1430415151-30948-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbD3SbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 14:31:03 -0400
Content-Disposition: inline
In-Reply-To: <1430415151-30948-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, Apr 30 2015 at  1:32pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> This way we can reused the same code any attachment method, not just those
> requested from dm-mpath.

Don't think feature bisectability matters on this patchset does it?
Can't we split dm-mpath and scsi_dh changes into separate patches?

Risk is I push the dm changes but SCSI doesn't get around to it within
the same cycle... we just cannot let that happen though.
