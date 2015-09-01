From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/23] scsi_dh_alua: Make stpg synchronous
Date: Tue, 1 Sep 2015 12:04:50 +0200
Message-ID: <20150901100450.GA9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34566 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbbIAKEw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:04:52 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:41:09PM +0200, Hannes Reinecke wrote:
> We should be issuing STPG synchronously as we need to
> evaluate the return code on failure.

This looks right, but I think the patch needs to be split and needs
a way better changelog.

patch 1:
 - factor out the alua_stpg helper

patch 2:
 - async STPG
 - please explain that alua_activate will now block and why this is ok

patch 3:
 - add the new call to alua_rtpg and why it's added
