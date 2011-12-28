From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Date: Wed, 28 Dec 2011 13:19:18 -0800
Message-ID: <20111228211918.GA3516@google.com>
References: <20111222233843.GR17084@google.com>
 <20111222154427.89b245c7.akpm@linux-foundation.org>
 <20111222234639.GS17084@google.com>
 <20111223004244.GU17084@google.com>
 <alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
 <20111225010238.GA6013@htj.dyndns.org>
 <alpine.LSU.2.00.1112280010550.1398@eggly.anvils>
 <20111228164836.GP17712@google.com>
 <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
 <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55931 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207Ab1L1VTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Dec 2011 16:19:24 -0500
Content-Disposition: inline
In-Reply-To: <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org

On Wed, Dec 28, 2011 at 09:55:12AM -0800, Tejun Heo wrote:
> Hello,
>=20
> On Wed, Dec 28, 2011 at 9:50 AM, Hugh Dickins <hughd@google.com> wrot=
e:
> > "It's the tmpfs swapping test that I've been running, with variatio=
ns,
> > for years. =A0System booted with mem=3D700M and 1.5G swap, two repe=
titious
> > make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that beca=
use
> > the balance of built to unbuilt source grows smaller with later ker=
nels),
> > one directly in a tmpfs, the other in a 1k-block ext2 (that I drive=
 with
> > ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs fi=
le."
> >
> > I doubt much of that (quoted from an older mail to someone else abo=
ut
> > one of the many other bugs it's found) is relevant: maybe just plen=
ty
> > of file I/O and swapping.
>=20
> Plain -j4 build isn't triggering anything.  I'll try to replicate the=
 condition.

It's not too reliable but I can reproduce it with -j 22 allmodconfig
build inside qemu w/ 512M of memory.  I'll try to find out what's
going on.

Thanks.

--=20
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
