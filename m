From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Date: Thu, 1 Jan 2009 19:12:23 +0100
Message-ID: <20090101181223.GA29913@logfs.org>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <495C8B65.4010202@panasas.com> <495C92C8.5040702@garzik.org> <495CD1C4.1030605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <495CD1C4.1030605@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, open-osd development <osd-dev@open-osd.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, avishay@gmail.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 1 January 2009 16:23:00 +0200, Benny Halevy wrote:
>=20
> Personally, I'm not sure if maintaining that intimate knowledge in a
> user space program is an ideal model with respect to keeping both
> in sync, avoiding code duplication, and dealing with upgrade issues
> (e.g. upgrading the kernel and not the user space utils)

None of those problems actually matter, because you will have them
anyway.  If your filesystem is any good, someone will reimplement it fo=
r
Windows, Grub, UBoot, Solaris or some other system.  And even if it
isn't any good, you still need to stay compatible with your own
implementation from last year.

Ok, maybe code duplication is a valid concern.  But that will hardly
outweigh the arguments in favor of a userland mkfs.  The only exception
I am aware of is jffs2, where a newly erased flash happens to be a vali=
d
(empty) filesystem.  And even there you can view flash_eraseall as a
trivial mkfs program. ;)

J=C3=B6rn

--=20
It's just what we asked for, but not what we want!
-- anonymous
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
