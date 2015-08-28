From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 10/10] scsi_dh: move 'dh_state' sysfs attribute to
 generic code
Date: Fri, 28 Aug 2015 13:14:02 -0700
Message-ID: <1440792842.2202.50.camel@HansenPartnership.com>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
	 <1440677823-11695-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56730 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbbH1UOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2015 16:14:04 -0400
In-Reply-To: <1440677823-11695-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:17 +0200, Hannes Reinecke wrote:
> As scsi_dh.c is now always compiled in we should be moving
> the 'dh_state' attribute to the generic code.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

This looks OK, but needs another reviewer.  If you could also fix up the
rejections caused by the if (!(scsi_dh = ...)) as well, that would be
great.

It's independent, so I pulled in the rest.

Thanks,

James


