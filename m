From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Date: Sun, 10 Aug 2008 16:39:23 -0700
Message-ID: <489F7C2B.30807@zytor.com>
References: <20080809220154.GO28946@ZenIV.linux.org.uk>	<E1KS2KD-0000he-00@gondolin.me.apana.org.au> <20080810133056.2fd69a20@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080810133056.2fd69a20@neptune.home>
Sender: linux-ide-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Al Viro <viro@ZenIV.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>, Wolfgang Walter <wolfgang.walter@stwm.de>
List-Id: linux-scsi@vger.kernel.org

Bruno Pr=E9mont wrote:
>=20
> Recompiling without viafb+squashfs patches makes the panic go away.
>=20
> So something from viafb or squashfs triggers the panic or prepare
> for something else to trigger it...
>=20

Out of those, viafb by far seems most likely.  Could you try compiling=20
with only one or the other?

	-hpa
