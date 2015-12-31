From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/20] revert commit a8e5a2d593cb ("[SCSI] scsi_dh_alua:
 ALUA handler attach should succeed while TPG is transitioning")
Date: Thu, 31 Dec 2015 13:54:33 +0100
Message-ID: <56852589.6020607@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
 <1449560260-53407-11-git-send-email-hare@suse.de>
 <20151230112220.GD14156@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbbLaMyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Dec 2015 07:54:37 -0500
In-Reply-To: <20151230112220.GD14156@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 12/30/2015 12:22 PM, Christoph Hellwig wrote:
> Maybe this should be folded into the next patch?
>
I did it on purpose, as this really is a clean revert,

> Otherwise looks fine:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
