From: Hannes Reinecke <hare@suse.de>
Subject: Re: integrate scsi_dh better into the scsi core V2
Date: Mon, 18 May 2015 19:36:32 +0200
Message-ID: <555A2320.8090105@suse.de>
References: <1431283260-13406-1-git-send-email-hch@lst.de> <20150518172851.GA8964@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbbERRgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2015 13:36:35 -0400
In-Reply-To: <20150518172851.GA8964@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 05/18/2015 07:28 PM, Christoph Hellwig wrote:
> Any chance to get reviews for the updated patch 1 and the new patch 3
> so that the whole series is in reviewed state?
>=20
Working on it.

There had been issues with v1 where multipath wouldn't start up properl=
y
if no hardware handlers were attached which I need to check before
sending out the review.

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
