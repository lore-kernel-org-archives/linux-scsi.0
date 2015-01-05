From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [LSF/MM ATTEND] discuss blk-mq related to DM-multipath
 and status of XCOPY
Date: Mon, 05 Jan 2015 14:25:05 +0100
Message-ID: <54AA90B1.1030201@suse.de>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbAENZL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 08:25:11 -0500
In-Reply-To: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/04/2015 06:16 PM, Mike Snitzer wrote:
> Hi,
>=20
> I'd like to attend LSF (and the first day of Vault).
>=20
> As a DM maintainer I'm open to discussing anything DM related.  In
> particular I'd like to at least have hallway track discussions with
> key people interested in DM multipath support for blk-mq devices.
> Keith Busch and I have gone ahead and implemented the bulk of this
> request-based DM support for blk-mq devices, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.g=
it/log/?h=3Ddm-for-3.20-blk-mq
>=20
> But Bart says he is seeing inconsistent performance now that the code
> appears relatively stable.  I'll continue analyzing this aspect of
> things and by the time LSF rolls around I hope the code to be sorted.
>=20
I'd be interested in having a discussion here, too.
hch and me have discussed an alternative approach for multipathing
(send the request directly and only clone request if the original
submission failed) which I'd like to discuss with a broader audience.
And I'd be interested in getting multipath to work with blk-mq, natural=
ly.

> Another topic we need to come to terms with is the state of XCOPY
> (whether the initial approach needs further work, etc) -- Mikulas
> Patocka reworked aspects of Martin's initial approach but it hasn't
> progressed upstream:
> https://www.redhat.com/archives/dm-devel/2014-October/msg00167.html
>=20
Yep. That definitely needs to be discussed.
Especially we'd need to discuss how to handle exceptions, seeing that
XCOPY might fail basically at any time.
And there are some corner-cases (bandwidth starvation on the target)
which needs to be discussed, too.

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
