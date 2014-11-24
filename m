From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 00/12] Re-implement am53c974 driver
Date: Mon, 24 Nov 2014 09:23:33 +0100
Message-ID: <5472EB05.3010509@suse.de>
References: <1416573716-73890-1-git-send-email-hare@suse.de> <20141124081403.GA18574@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbaKXIXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 03:23:36 -0500
In-Reply-To: <20141124081403.GA18574@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org

On 11/24/2014 09:14 AM, Christoph Hellwig wrote:
> I'm tempted to merge this into drivers-for-3.19 ASAP, any argument ag=
ainst
> that?  Guennadi, do you have any additional hardware to Hannes one re=
al and one
> virtual adapter to test this new driver on before?
>=20
Certainly not from me :-)

It would be nice to have it in, as then I could do some more
in-depth testing for EH async aborts and the EH rework in general.
And qemu would finally have all SCSI HBAs working again :-)

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
