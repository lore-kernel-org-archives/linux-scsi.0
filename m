From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/20] scsi_dh_alua: Allow workqueue to run synchronously
Date: Thu, 31 Dec 2015 14:54:18 +0100
Message-ID: <5685338A.5010801@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
 <1449560260-53407-13-git-send-email-hare@suse.de>
 <20151230132010.GB15270@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbbLaNyV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Dec 2015 08:54:21 -0500
In-Reply-To: <20151230132010.GB15270@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 12/30/2015 02:20 PM, Christoph Hellwig wrote:
> On Tue, Dec 08, 2015 at 08:37:32AM +0100, Hannes Reinecke wrote:
>> Some arrays may only capable of handling one STPG at a time,
>
> Which arrays?  We should have a quirk for them in the devinfo databas=
e
> instead of a module option.
>
ATM the only ones I know of is NetApp (both FAS and E-series; E-series=20
requires it, and FAS benefits greatly).
But this is not to say that these are the only ones, _and_ the more=20
obvious approach would be to add the handling to multipath-tools=20
settings, so I really would like to keep the module option for now.

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
