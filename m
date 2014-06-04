From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/6] First batch of logging cleanups
Date: Wed, 04 Jun 2014 07:50:52 +0200
Message-ID: <538EB3BC.7060401@suse.de>
References: <1401794577-102277-1-git-send-email-hare@suse.de> <yq11tv54p7w.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbaFDFuy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2014 01:50:54 -0400
In-Reply-To: <yq11tv54p7w.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 06/04/2014 12:12 AM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>
> Hannes> Hi all, this is the first patch of my SCSI logging cleanup.  =
The
> Hannes> basic idea here is to use dev_printk() and friends throughout
> Hannes> the midlayer, so that any logging messages are attached with =
the
> Hannes> correct device information.
>
> All patches look good to me (except I'd really like to see SCSI loggi=
ng
> die a horrible death. Sadly it's an exposed user interface and theref=
ore
> hard to nuke).
>
Hehe.
That's next in line.

Plan is to move all SCSI_LOGGING_ML_XXX over to scsi_tracing.
And then slowly working my way up.

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
