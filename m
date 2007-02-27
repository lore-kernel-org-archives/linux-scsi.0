From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 2/2] cciss: supercedes add shutdown support (replaces
 reboot notifier)
Date: Tue, 27 Feb 2007 12:26:34 -0800
Message-ID: <20070227122634.324fc8b1.akpm@linux-foundation.org>
References: <20070223204239.GA10570@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50538 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXB0Uak (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Feb 2007 15:30:40 -0500
In-Reply-To: <20070223204239.GA10570@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

> On Fri, 23 Feb 2007 14:42:39 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> This patch supercedes yesterdays cciss-shutdown patch. The primary difference is
> removing __devexit from cciss_remove_one. Instead of create another function I'd
> rather use the code that was intended to perform the cleanup and cache flush. I've
> tested as a loadable module and statically linked without error.
> Please consider this for inclusion.

Please don't document patches like this.

The entirety of your changelog and the Subject: are relative to a patch
which will never hit the mainline git tree.  Put yourself in the position
of someone reading the git changelogs in a year's time.  They're going to
be left scratching their heads at the above, aren't they?

Always include a complete and standalone, not-referential-to-an-old-patch
changelog in each iteration of a patch.

Always choose a suitable Subject:

Yes, it's good to tell us things about how this patch differs from the
previous one.  That info can be placed after the ^--- which comes after
your signed-off-by:, or can be placed at the top of the email, as long as
the full permanent changelog is there too.

Bottom line: you are submitting code and its documentation into the
permanent kernel record, not just the mailing list.  Try to make it
appropriate, thanks.


Please send a new Subject: and changlog for this patch.

