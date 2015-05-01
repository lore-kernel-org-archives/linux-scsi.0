From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/9] dm-mpath, scsi_dh: don't let dm detach device
 handlers
Date: Fri, 1 May 2015 09:58:09 -0400
Message-ID: <20150501135808.GB4810@redhat.com>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
 <1430415151-30948-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbbEAN6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2015 09:58:10 -0400
Content-Disposition: inline
In-Reply-To: <1430415151-30948-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, Apr 30 2015 at  1:32pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> While allowing dm-mpath to attach device handlers is a functionality we need
> for backwards compatibility reason there is no reason to reference count
> them and detach them if dm-mpath stops using the device for some reason.
> 
> If the device handler works for the given device it can just stay attached.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>
