From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: crash unrelated to sym53c8xx
Date: Thu, 2 Apr 2009 21:39:27 +0200
Message-ID: <20090402193927.GA7106@nik-comp.linuxbox.cz>
References: <20090402075404.GA9784@develbox.linuxbox.cz> <20090402112338.GO8014@parisc-linux.org> <20090402122610.GB9784@develbox.linuxbox.cz> <20090402122808.GC9784@develbox.linuxbox.cz> <20090402124924.GP8014@parisc-linux.org> <20090402125954.GD9784@develbox.linuxbox.cz> <20090402130156.GQ8014@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:54134 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbZDBUAg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 16:00:36 -0400
Content-Disposition: inline
In-Reply-To: <20090402130156.GQ8014@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, nikola.ciprich@linuxbox.cz

OK, now I understand, thanks for explaining...
unfortunately I'm now unable to reproduce the crash including backtrace, machine always
hangs completely without any error reported :(
I've setup netconsole logging and I'll wait if it crashes and report something during normal
usage.
I'll report if it happens.
thanks for Your time.
have a nice day
nik

On Thu, Apr 02, 2009 at 07:01:56AM -0600, Matthew Wilcox wrote:
> On Thu, Apr 02, 2009 at 02:59:54PM +0200, Nikola Ciprich wrote:
> > > There's a few reasons this warning hasn't been fixed yet:
> > > 
> > >  - It only appears on module unload.  Most people don't unload sym53c8xx.
> > >  - The problem that it's warning about is only a problem on ARM.
> > >    There's not a huge userbase of ARM users with sym53c8xx cards.
> > >  - Fixing it requires a fairly large rewrite of how sym2 manages its
> > >    memory.  I've done about half the work required, but I've basically
> > >    run out of interest.
> > Hmm, maybe I don't understand what You mean by ARM, but it's i686 machine,
> > not arm (actually it's opteron, but running i686 OS).
> > but if it's reallu harmless, I don't have that big problem with it. only the crashes
> > really worry me :)
> 
> The warning is there on x86 to warn us that we're doing something that
> will cause problems on ARM.
> 
> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
