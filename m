From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: crash unrelated to sym53c8xx
Date: Thu, 2 Apr 2009 14:59:54 +0200
Message-ID: <20090402125954.GD9784@develbox.linuxbox.cz>
References: <20090402075404.GA9784@develbox.linuxbox.cz> <20090402112338.GO8014@parisc-linux.org> <20090402122610.GB9784@develbox.linuxbox.cz> <20090402122808.GC9784@develbox.linuxbox.cz> <20090402124924.GP8014@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw3.lbox.cz ([62.245.111.133]:44368 "EHLO develbox.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751158AbZDBM7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 08:59:55 -0400
Content-Disposition: inline
In-Reply-To: <20090402124924.GP8014@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, nikola.ciprich@linuxbox.cz

> Yes, that's somewhat more useful ... the tail of the stack trace in the
> photo indicates this isn't (at least directly) a bug in the sym53c8xx
> driver.  Can you get the rest of the crash message?  netconsole might
> help here if you don't have a serial console.
OK, I'll try to get the whole message using IPMI console.
I'll post it in ~2 hours...

> There's a few reasons this warning hasn't been fixed yet:
> 
>  - It only appears on module unload.  Most people don't unload sym53c8xx.
>  - The problem that it's warning about is only a problem on ARM.
>    There's not a huge userbase of ARM users with sym53c8xx cards.
>  - Fixing it requires a fairly large rewrite of how sym2 manages its
>    memory.  I've done about half the work required, but I've basically
>    run out of interest.
Hmm, maybe I don't understand what You mean by ARM, but it's i686 machine,
not arm (actually it's opteron, but running i686 OS).
but if it's reallu harmless, I don't have that big problem with it. only the crashes
really worry me :)
