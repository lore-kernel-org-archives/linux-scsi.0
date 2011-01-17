From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Mon, 17 Jan 2011 12:16:53 +0100
Message-ID: <1295263013.24967.6.camel@thorin>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	 <20110116141105.59e5b3a2@stein>
	 <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
	 <20110117000659.57352da7@stein>
	 <AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
	 <20110116231901.GF22723@ZenIV.linux.org.uk>
	 <AANLkTikWHkfb1-Yh_O=rYEqzgz48rwRggCp6uhr+E86J@mail.gmail.com>
	 <20110117015220.11b43ae7@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110117015220.11b43ae7@stein>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-17 at 01:52 +0100, Stefan Richter wrote:
[...] 
> We already have different UIs.  But perhaps we have too much UI down in
> the Kconfig files.  I.e., perhaps Kconfig shouldn't know the difference

IOMHO not really.

> between depends-on and select.  Let the different UIs present the

The UI should know the difference as it should guide/force the user -
especially the less experienced ones which aren't expected to know every
bit of hardware and kernel-internal stuff (as in "do I need gzip
compression?").

And there are two (IMHO very) different semantics:
- select: enables/activates/includes necessary other parts (like the
  "gzip compression" example from above and other library-like).
- depends on: to purposely disable knobs because it makes no sense to
  configure e.g. ext-specific stuff if I don't have/want ext or because
  the physical hardware is not present/available (find more and better
  in Al Viros mail of course).

> dependency graph to the operator in different ways, suitable to different
> tasks.

That would be quite cute.

> /handwave off.
AOL.
Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

