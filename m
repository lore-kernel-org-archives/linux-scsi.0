From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Wed, 05 Nov 2014 15:12:41 +0100
Message-ID: <545A3059.8030004@suse.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de> <1414661229-15199-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaKEOMm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2014 09:12:42 -0500
In-Reply-To: <1414661229-15199-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On 10/30/2014 10:27 AM, Christoph Hellwig wrote:
> The calling conventions for this function where bad as it could retur=
n
> -ENODEV both for a device not currently online and a not recognized i=
octl.
>=20
> Add a new scsi_ioctl_block_when_processing_errors function that wraps
> scsi_block_when_processing_errors with the a special case for the
> SG_SCSI_RESET ioctl command, and handle the SG_SCSI_RESET case itself
> in scsi_ioctl.  All callers of scsi_ioctl now must call the above hel=
per
> to check for the EH state, so that the ioctl handler itself doesn't
> have to.
>=20
> Reported-by: Robert Elliott <Elliott@hp.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
