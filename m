From: Hannes Reinecke <hare@suse.de>
Subject: Re: integrate scsi_dh better into the scsi core V2
Date: Fri, 19 Jun 2015 15:06:46 +0200
Message-ID: <558413E6.7010503@suse.de>
References: <1431283260-13406-1-git-send-email-hch@lst.de> <20150518172851.GA8964@infradead.org> <555A2320.8090105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbbFSNGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 09:06:49 -0400
In-Reply-To: <555A2320.8090105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 05/18/2015 07:36 PM, Hannes Reinecke wrote:
> On 05/18/2015 07:28 PM, Christoph Hellwig wrote:
>> Any chance to get reviews for the updated patch 1 and the new patch =
3
>> so that the whole series is in reviewed state?
>>
> Working on it.
>=20
> There had been issues with v1 where multipath wouldn't start up prope=
rly
> if no hardware handlers were attached which I need to check before
> sending out the review.
>=20
So, I've been looking into it.
While the principle is okay, there are some issues with the current
state (eg sdev->handler is never assigned).
Do you have an updated patchset or should I send some incremental
patches?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
