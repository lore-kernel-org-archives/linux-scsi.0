From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 00/14] libata: ZAC support
Date: Tue, 26 Apr 2016 07:47:54 +0200
Message-ID: <571F010A.2010105@suse.de>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
 <4CCE9B16-A756-4C57-8C49-B4CD66DE73DE@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4CCE9B16-A756-4C57-8C49-B4CD66DE73DE@hgst.com>
Sender: linux-ide-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>, Tejun Heo <tj@kernel.org>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/26/2016 02:42 AM, Damien Le Moal wrote:
>=20
> Hannes,
>=20
>> Hi all,
>>
>> here's a patchset implementing ZAC support for libata.
>>
>> This is the second part of a larger patchset for ZAC/ZBC support;
>> it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue an=
d
>> the patchset 'libata: SATL update' queued in tj/for-4.7-zac.
>> The full patchset can be found at:
>>
>> git.kernel.org/hare/scsi-devel/h/zbc.v6
>=20
> I do not see a zbc.v6 branch in your scsi-devel tree...
>=20
You do now :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
