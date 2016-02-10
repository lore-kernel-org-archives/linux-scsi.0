From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Wed, 10 Feb 2016 17:06:18 +0100
Message-ID: <20160210160618.GU27969@c203.arch.suse.de>
References: <568FE922.9090004@sandisk.com>
 <yq1oachqehs.fsf@sermon.lab.mkp.net>
 <1453251809.2320.56.camel@HansenPartnership.com>
 <56B025E4.9010009@sandisk.com>
 <1454413585.2349.11.camel@HansenPartnership.com>
 <20160203233816.00004da7@localhost>
 <20160210140522.GT27969@c203.arch.suse.de>
 <1455118491.2341.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbcBJQGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2016 11:06:22 -0500
Content-Disposition: inline
In-Reply-To: <1455118491.2341.6.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>, Hannes Reinecke <hare@suse.de>

On Wed, Feb 10, 2016 at 07:34:51AM -0800, James Bottomley wrote:
> On Wed, 2016-02-10 at 15:05 +0100, Johannes Thumshirn wrote:
> > On Wed, Feb 03, 2016 at 11:38:16PM +0100, Sebastian Herbszt wrote:
> > > James Bottomley wrote:
> > > > On Mon, 2016-02-01 at 19:43 -0800, Bart Van Assche wrote:
> > > > > On 01/19/16 17:03, James Bottomley wrote:
> > > > > > On Tue, 2016-01-19 at 19:30 -0500, Martin K. Petersen wrote=
:
> > > > > > > > > > > > "Bart" =3D=3D Bart Van Assche <
> > > > > > > > > > > > bart.vanassche@sandisk.com>
[..]
> > >=20
> > > Sebastian
> >=20
> > Hi James, Bart, Martin
> >=20
> > Have you already decided, which of the two patches you favour and=20
> > when it'llbe included?
> >=20
> > I have several customer reports that hit this lockup and I don't wa=
nt=20
> > to include one of the patches from the list just to find out the=20
> > other one's is used in mainline.
>=20
> Well, unless the target allocation bug gets fixed in Bart's, it will
> have to be the last_scan one.  It's more a hack than a fix, but I
> suppose it will do as a bandaid in the meantime.
>=20
> If you have diagnosed this at customers, I'd still like to know what'=
s
> holding the devices on removal.
>=20
> Thanks,
>=20
> James

I'll setup a test environment tomorrow and try to get some crash dumps =
with
the current HEAD.

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
