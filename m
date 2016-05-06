From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 00/14] libata: ZAC support
Date: Fri, 6 May 2016 13:05:36 +0200
Message-ID: <572C7A80.4000903@suse.de>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
 <20160425201627.GI7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160425201627.GI7822@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/25/2016 10:16 PM, Tejun Heo wrote:
> Hello,
>=20
> On Mon, Apr 25, 2016 at 12:45:42PM +0200, Hannes Reinecke wrote:
>> here's a patchset implementing ZAC support for libata.
>>
>> This is the second part of a larger patchset for ZAC/ZBC support;
>> it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue an=
d
>> the patchset 'libata: SATL update' queued in tj/for-4.7-zac.
>=20
> The patches look good from libata side.  If others are okay with it, =
I
> can pull mkp/4.7/scsi-queue into tj/for-4.7-zac and apply this series
> on top of it.
>=20
Ping?

I can easily split off the libsas bits into a different patchset if
this turns out to be an issue.
But it would be really good if this could make it 4.7, it will help
further integration a _lot_.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
