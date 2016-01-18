From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 15/24] scsi_devinfo: move scsi_get_device_flags into
	scsi_devinfo.h
Date: Mon, 18 Jan 2016 18:49:21 +0100
Message-ID: <20160118174921.GC24303@lst.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de> <1452672599-9820-16-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33448 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbcARRtW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 12:49:22 -0500
Content-Disposition: inline
In-Reply-To: <1452672599-9820-16-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 09:09:50AM +0100, Hannes Reinecke wrote:
> scsi_get_device_flags is just a wrapper for scsi_get_device_flags_keyed.
> The latter is exported, the former isn't. And both functions _and_
> the 'key' values are only defined in the (internal) scsi_priv.h
> header file.
> This patch moves these definitions into scsi_devinfo.h to make them
> available for other modules.

This looks fine, but a little pointless..
