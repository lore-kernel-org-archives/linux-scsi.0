From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Wed, 08 Dec 2010 01:12:28 +0900
Message-ID: <1291738348.1638.9.camel@leonhard>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291737421.17668.5.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

2010-12-07 (=ED=99=94), 09:57 -0600, James Bottomley:
> Um so this is definitely used in the MODULE_DEVICE_TABLE just below.
>=20
> I deduce you have some type of config which causes that to be a nop
> (say !CONFIG_MODULE)?  In which case, surely the correct fix is in
> module.h?
>=20

Hi,

MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODULE) so
allyesconfig build always emits the warnings. Possible patch for this
would be wraping it up in #ifdefs but when I sent a same patch to Greg
KH he didn't want to add more #ifdefs in .c files.

--=20
Regards,
Namhyung Kim
