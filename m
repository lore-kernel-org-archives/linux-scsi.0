From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: 2.6.28-rc6-tip fails to build with gcc 4.4.0
Date: Mon, 24 Nov 2008 15:42:36 +0100
Message-ID: <20081124144236.GA2318@gentoox2.trippelsdorf.de>
References: <492AB9FD.5010602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753538AbYKXOmu@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <492AB9FD.5010602@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 24, 2008 at 04:28:13PM +0200, T=F6r=F6k Edwin wrote:
> Hi,
>=20
> Using gcc version 4.4.0 20081120 (experimental) [trunk revision 14205=
5]
> I can't build latest tip/master (commit
> b27fef5b222564b6e7ae71f7110c233b2fb45a38)
>=20
> drivers/built-in.o: In function `sd_revalidate_disk':
> sd.c:(.text+0x8bc76): undefined reference to `____ilog2_NaN'
> make: *** [.tmp_vmlinux1] Error 1
>=20
> Apparently gcc determines that sector_size can have an invalid consta=
nt
> value as ilog2's parameter in sd_read_capacity.

> Did it find a real bug in sd.c, or is it a gcc bug?

See: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D36359

Setting CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy in your .config should fix it f=
or
now.

--=20
Markus
