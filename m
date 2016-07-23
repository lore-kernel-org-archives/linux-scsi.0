From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Sat, 23 Jul 2016 14:43:27 +0200
Message-ID: <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

On 07/22/2016 10:45 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> Add a sysfs queue attribute 'zoned' to display the zone layou=
t
> Hannes> for zoned devices.
>=20
> Not quite one value per file :(
>=20
Yes.
But I wanted to display the zone layout in a concise way allowing
user-space programs to determine the zone layout without having to
issue a 'REPORT ZONES' command themselves.
I found it slightly pointless to add one sysfs entry per zone,
and at the same time a simple 'zone_size' attribute wouldn't cover all
possibilities.

However, as SMR drives seem to stabilise around having a fixed zone siz=
e
(with a possible exemption of the last zone to cover left-overs)
I'd be fine a replace this with a single 'zone_size' attribute which
could be set to eg '-1' for drives which indeed would implement variabl=
e
zone sizes.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-block" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
