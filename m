From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/8] target_core_alua: disallow READ_CAPACITY when in
 standby
Date: Thu, 18 Jun 2015 16:32:54 +0200
Message-ID: <5582D696.4010507@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de> <1434620622-65391-8-git-send-email-hare@suse.de> <5582AE3D.3010006@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5582AE3D.3010006@bootc.net>
Sender: target-devel-owner@vger.kernel.org
To: Chris Boot <bootc@bootc.net>, Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 06/18/2015 01:40 PM, Chris Boot wrote:
> On 18/06/15 10:43, Hannes Reinecke wrote:
>> Strictly speaking SPC doesn't require READ CAPACITY and friends
>> to be supported while in the port is in standby.
>=20
> Hi Hannes,
>=20
> I'd really rather this didn't go away. Yes, strictly speaking SPC
> doesn't require these commands but Linux in practice does, and ISTR t=
his
> was added at my request too.
>=20
> We need it on our storage setups to prevent the Linux SCSI stack from
> exploding. If this is removed here, they'll start exploding again unt=
il
> the fix goes in and the initiators are updated.
>=20

This was exactly why I added it, so that one could go about and fix
the linux SCSI stack :-)

> Could this please be kept as an option or something?
>=20
Yeah, I see what I can do.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
