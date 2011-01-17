From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Mon, 17 Jan 2011 01:52:20 +0100
Message-ID: <20110117015220.11b43ae7@stein>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	<20110116141105.59e5b3a2@stein>
	<1295214807.22813.57.camel@haakon2.linux-iscsi.org>
	<20110117000659.57352da7@stein>
	<AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
	<20110116231901.GF22723@ZenIV.linux.org.uk>
	<AANLkTikWHkfb1-Yh_O=rYEqzgz48rwRggCp6uhr+E86J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38309 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1AQAwk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Jan 2011 19:52:40 -0500
In-Reply-To: <AANLkTikWHkfb1-Yh_O=rYEqzgz48rwRggCp6uhr+E86J@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>

On Jan 16 Linus Torvalds wrote:
> Or do you expect a high-quality implementation of a configuration
> script to allow the user to just say "I want ocfs2", and then figure
> out the dependencies and solve them for you?
> 
> I'd say that the latter case is OBVIOUSLY the quality implementation,
> while the former one is just stupid.

As Al noted, there also needs to be a convenient way to *disable* options.

Hence, the Kconfig files should merely declare the dependencies.  Then,
some user interfaces should deal with the this database of dependencies
and let different people achieve different goals as easily as possible.

We already have different UIs.  But perhaps we have too much UI down in
the Kconfig files.  I.e., perhaps Kconfig shouldn't know the difference
between depends-on and select.  Let the different UIs present the
dependency graph to the operator in different ways, suitable to different
tasks.

/handwave off.
-- 
Stefan Richter
-=====-==-== ---= =---=
http://arcgraph.de/sr/
