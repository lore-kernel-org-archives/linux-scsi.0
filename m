From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Mon, 18 Nov 2002 11:02:00 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211181054330.2109-100000@serv>
References: <20021118085928.82D7F2C30D@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021118085928.82D7F2C30D@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Doug Ledford <dledford@redhat.com>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Viro <viro@math.psu.edu>, Linus Torvalds <torvalds@transmeta.com>

Hi,

On Mon, 18 Nov 2002, Rusty Russell wrote:

> And it *still* means you need two paths for your code: one for "I know
> it's not actually "active" yet, but I'm doing init and I need to
> access it anyway".  So every interface gains significant complexity by
> effectively implementing their own "live" flag...

Rusty, you know how refcounts work? Especially the "if 
(atomic_dec_and_test(&obj->ref)) cleanup(obj)" part is really interesting.

bye, Roman

