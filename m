From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Date: Wed, 28 Dec 2011 09:55:12 -0800
Message-ID: <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
References: <20111222150836.af172886.akpm@linux-foundation.org>
	<20111222232036.GP17084@google.com>
	<20111222152427.c944c747.akpm@linux-foundation.org>
	<20111222233843.GR17084@google.com>
	<20111222154427.89b245c7.akpm@linux-foundation.org>
	<20111222234639.GS17084@google.com>
	<20111223004244.GU17084@google.com>
	<alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
	<20111225010238.GA6013@htj.dyndns.org>
	<alpine.LSU.2.00.1112280010550.1398@eggly.anvils>
	<20111228164836.GP17712@google.com>
	<alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Wed, Dec 28, 2011 at 9:50 AM, Hugh Dickins <hughd@google.com> wrote:
> "It's the tmpfs swapping test that I've been running, with variations=
,
> for years. =A0System booted with mem=3D700M and 1.5G swap, two repeti=
tious
> make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that becaus=
e
> the balance of built to unbuilt source grows smaller with later kerne=
ls),
> one directly in a tmpfs, the other in a 1k-block ext2 (that I drive w=
ith
> ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs file=
=2E"
>
> I doubt much of that (quoted from an older mail to someone else about
> one of the many other bugs it's found) is relevant: maybe just plenty
> of file I/O and swapping.

Plain -j4 build isn't triggering anything.  I'll try to replicate the c=
ondition.

Thanks.

--=20
tejun
