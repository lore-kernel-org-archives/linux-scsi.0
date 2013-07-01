From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] scsi: Return ENODATA on medium error
Date: Mon, 01 Jul 2013 11:51:55 +0200
Message-ID: <51D1513B.1030908@suse.de>
References: <1372666331-66996-1-git-send-email-hare@suse.de> <1372666331-66996-5-git-send-email-hare@suse.de> <51D14813.6070803@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <51D14813.6070803@ce.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 07/01/2013 11:12 AM, Jun'ichi Nomura wrote:
> On 07/01/13 17:12, Hannes Reinecke wrote:
>> When a medium error is detected the SCSI stack should return
>> ENODATA to the upper layers.
>=20
> Hi Hannes,
>=20
> since you change the error code from -EREMOTEIO to -ENODATA/-ENOSPC,
> upper layers that checks -EREMOTEIO have to be updated as well.
>=20
> Something like below for dm-multipath.
> It seems btrfs checking -EREMOTEIO, too.
>=20
Good point.

Will be updating the patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
