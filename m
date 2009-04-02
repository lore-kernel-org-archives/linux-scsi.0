From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: crash unrelated to sym53c8xx
Date: Thu, 2 Apr 2009 07:01:56 -0600
Message-ID: <20090402130156.GQ8014@parisc-linux.org>
References: <20090402075404.GA9784@develbox.linuxbox.cz> <20090402112338.GO8014@parisc-linux.org> <20090402122610.GB9784@develbox.linuxbox.cz> <20090402122808.GC9784@develbox.linuxbox.cz> <20090402124924.GP8014@parisc-linux.org> <20090402125954.GD9784@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49303 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZDBNB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 09:01:58 -0400
Content-Disposition: inline
In-Reply-To: <20090402125954.GD9784@develbox.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, nikola.ciprich@linuxbox.cz

On Thu, Apr 02, 2009 at 02:59:54PM +0200, Nikola Ciprich wrote:
> > There's a few reasons this warning hasn't been fixed yet:
> > 
> >  - It only appears on module unload.  Most people don't unload sym53c8xx.
> >  - The problem that it's warning about is only a problem on ARM.
> >    There's not a huge userbase of ARM users with sym53c8xx cards.
> >  - Fixing it requires a fairly large rewrite of how sym2 manages its
> >    memory.  I've done about half the work required, but I've basically
> >    run out of interest.
> Hmm, maybe I don't understand what You mean by ARM, but it's i686 machine,
> not arm (actually it's opteron, but running i686 OS).
> but if it's reallu harmless, I don't have that big problem with it. only the crashes
> really worry me :)

The warning is there on x86 to warn us that we're doing something that
will cause problems on ARM.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
