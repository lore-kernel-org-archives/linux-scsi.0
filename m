From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 14:45:11 -0600
Message-ID: <20080419204511.GP20637@parisc-linux.org>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46547 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbYDSUpd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 16:45:33 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sat, Apr 19, 2008 at 01:14:23PM -0700, Linus Torvalds wrote:
> So people: stop this total *idiocy* with "select is bad". It's not. The 
> lack of select is *much* worse.

Could we consider applying this patch then?

----

'select' not Considered Evil

While select should be used with care, it is not actually evil.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 649cb87..dacfcf2 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -104,9 +104,9 @@ applicable everywhere (see syntax).
   Reverse dependencies can only be used with boolean or tristate
   symbols.
   Note:
-	select is evil.... select will by brute force set a symbol
-	equal to 'y' without visiting the dependencies. So abusing
-	select you are able to select a symbol FOO even if FOO depends
+	select should be used with care.  It can set a symbol
+	without visiting the dependencies.  By abusing select you are
+	able to select a symbol FOO even if FOO depends
 	on BAR that is not set. In general use select only for
 	non-visible symbols (no prompts anywhere) and for symbols with
 	no dependencies. That will limit the usefulness but on the

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
