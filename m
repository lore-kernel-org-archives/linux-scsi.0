From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/20] scsi_dh_alua: parse target device id
Date: Fri, 24 Jul 2015 17:07:40 +0200
Message-ID: <20150724150740.GB29434@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55930 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbbGXPHm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 11:07:42 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On Wed, Jul 08, 2015 at 11:06:12AM +0200, Hannes Reinecke wrote:
> Parse VPD descriptor to figure out the device identification.
> As devices might implement several descriptors the order
> of preference is:
> - NAA IEE Registered Extended
> - EUI-64 based 16-byte
> - EUI-64 based 12-byte
> - NAA IEEE Registered
> - NAA IEEE Extended
> A SCSI name string descriptor is preferred to all of them
> if the identification is longer than 16 bytes.

Can you move this to scsi_mod.ko?  I'll need the same code for the NFS
SCSI layout driver soon.

