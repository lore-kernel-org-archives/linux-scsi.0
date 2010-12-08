From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Thu, 09 Dec 2010 01:20:20 +0900
Message-ID: <1291825220.1741.9.camel@leonhard>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site> <1291738348.1638.9.camel@leonhard>
	 <1291739449.17668.9.camel@mulgrave.site>
	 <1291742693.1638.22.camel@leonhard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291742693.1638.22.camel@leonhard>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2010-12-08 (=EC=88=98), 02:24 +0900, Namhyung Kim:
> 2010-12-07 (=ED=99=94), 10:30 -0600, James Bottomley:
> > On Wed, 2010-12-08 at 01:12 +0900, Namhyung Kim wrote:
> > > MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODU=
LE) so
> > > allyesconfig build always emits the warnings. Possible patch for =
this
> > > would be wraping it up in #ifdefs but when I sent a same patch to=
 Greg
> > > KH he didn't want to add more #ifdefs in .c files.
> >=20
> > I didn't mean changing any c files.  I meant fixing the module incl=
ude
> > to make the table used even in the !MODULE case.  That way we only =
alter
> > one file instead of a significant proportion of the drivers.
> >=20
>=20
> It would not be a _significant_ proportion because normal drivers may
> refer the table in their driver struct. :)
>=20
> Anyway the patch below looks good to me. I'll happily drop my patches=
 if
> you apply this in your tree.
>=20

Hi,

As akpm told me, using DEFINE_PCI_DEVICE_TABLE could also remove the
warnings (probably by making the table const) but it still requires
modifying .c files. What do you think?


--=20
Regards,
Namhyung Kim
