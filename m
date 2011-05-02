From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [SCSI] scsi_dh_alua: Attach to UNAVAILABLE/OFFLINE AAS
 devices
Date: Mon, 02 May 2011 08:00:32 +0200
Message-ID: <4DBE4880.8090303@suse.de>
References: <201104261827.06024.marting@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42785 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1EBGDc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2011 02:03:32 -0400
In-Reply-To: <201104261827.06024.marting@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin George <marting@netapp.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On 04/26/2011 02:57 PM, Martin George wrote:
> The SCSI ALUA handler currently fails to attach to devices
> reporting an UNAVAILABLE/OFFLINE AAS. But given that an
> UNAVAILABLE/OFFLINE AAS can transition to other states
> like ACTIVE/OPTIMIZED, ACTIVE/NON-OPTIMIZED, etc. as per
> SPC4, this ALUA handler behavior should be rectified so
> as to attach to devices which also report an
> UNAVAILABLE/OFFLINE AAS.
>
> The below patch enables the same.
>
> Signed-off-by: Martin George<marting@netapp.com>

Patch is correct. Even a path in state 'UNAVAILABLE' or 'OFFLINE'
responds to ALUA commands and thus should be handle by the alua
device_handler.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
