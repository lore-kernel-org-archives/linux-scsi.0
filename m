From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v8 00/17] add fixes, device quirks, error recovery,
Date: Fri, 11 Mar 2016 09:51:15 +0100
Message-ID: <56E28703.4090702@suse.de>
References: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org>
 <yq1k2l9lozl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <yq1k2l9lozl.fsf@sermon.lab.mkp.net>
Sender: linux-arm-msm-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/11/2016 03:36 AM, Martin K. Petersen wrote:
>>>>>> "Yaniv" =3D=3D Yaniv Gardi <ygardi@codeaurora.org> writes:
>=20
> Yaniv> V8: fixed cyclic dependency by removing ufs_quirk.c that was
> Yaniv> previously added in V7 06/17, and moving its code into ufshcd.=
c
>=20
> Patch 6 is now different yet it retains Reviewed-by: tags from the
> previous version. These should have been removed.
>=20
> But if Hannes is OK with the changed version you don't need to
> resend. Hannes, if you would be so kind to take a second look?
>=20
As indicated, I'm still not happy with the timeout handler, it
really should be sending real command aborts and not just extending
the timeout.
But it's better then nothing, and having this patchset in leaves us
with more time to discuss other matters.
EG ioctl interfaces ;-)

So:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
