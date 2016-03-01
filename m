From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/6] scsi: Add 'access_state' and 'preferred_path'
	attribute
Date: Tue, 1 Mar 2016 14:06:04 +0100
Message-ID: <20160301130604.GC7616@lst.de>
References: <1456808143-88932-1-git-send-email-hare@suse.de> <1456808143-88932-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40402 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbcCANGH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 08:06:07 -0500
Content-Disposition: inline
In-Reply-To: <1456808143-88932-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Tue, Mar 01, 2016 at 05:55:38AM +0100, Hannes Reinecke wrote:
> Add an 'access_state' field to struct scsi_device
> and display them in sysfs as 'access_state' and
> 'preferred_path' attribute.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(I don't care about the *printf holy war for constant strings.  In all
 truth sysfs should switch to the seq_file API ASAP and end that misery..)
