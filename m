From: Joe Perches <joe@perches.com>
Subject: Re: [TRIVIAL PATCH] block: Correct misuses of 0x%<decimal>
Date: Mon, 03 Aug 2015 01:03:46 -0700
Message-ID: <1438589026.30149.15.camel@perches.com>
References: <1438547113.29569.5.camel@perches.com>
	 <9547AF94-2168-4987-AD89-B7F111084CC2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9547AF94-2168-4987-AD89-B7F111084CC2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yalin wang <yalin.wang2010@gmail.com>
Cc: Don Brace <don.brace@pmcs.com>, linux-kernel@vger.kernel.org, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-08-03 at 15:25 +0800, yalin wang wrote:
> > On Aug 3, 2015, at 04:25, Joe Perches <joe@perches.com> wrote:
> >=20
> > Correct misuse of 0x%d in logging messages.
> >=20
[]
> why not use like this : dev_dbg(&h->pdev->dev, "   Max outstanding=20
> commands =3D %#x\n=E2=80=9D  ?=20
> %#x will add 0x prefix automatically .

It's generally a consistency thing.
A 0 value would be emitted as 0 and not 0x0.
