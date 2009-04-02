From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: sym53c8xx: WARNING on module unload, crashes on further usage
Date: Thu, 2 Apr 2009 14:26:10 +0200
Message-ID: <20090402122610.GB9784@develbox.linuxbox.cz>
References: <20090402075404.GA9784@develbox.linuxbox.cz> <20090402112338.GO8014@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw3.lbox.cz ([62.245.111.133]:58136 "EHLO develbox.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752170AbZDBM0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 08:26:13 -0400
Content-Disposition: inline
In-Reply-To: <20090402112338.GO8014@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, nikola.ciprich@linuxbox.cz

Hi Matthew,
well, I've got VERY crappy screen photo, my collegue made using his cellphone, You can check
it on http://nik.lbox.cz/downloads/sym53c8xx-crash.jpg
But we can quite easily reproduce the problem, I'll try to do it today evening and make a
better screenshot...
I'll report further then.
Regarding warning, couldn't it then be surpressed, if it's harmless? Kernel then gets tainted,
which makes me a bit nervous :-)
regards
nik

On Thu, Apr 02, 2009 at 05:23:38AM -0600, Matthew Wilcox wrote:
> On Thu, Apr 02, 2009 at 09:54:04AM +0200, Nikola Ciprich wrote:
> > Hi,
> > we're experiencing problems using changer connected on LSI Logic / Symbios Logic 53c875 adaptor (using sym53c8xx module).
> > Sometimes changer gets stuck, and reloading sym53c8xx module is the only way to help. But it alwas issues following warning,
> > and on subsequent mtx usage, the whole machine usually crashes...
> 
> The warning is actually harmless.  What error messages do you get when
> the machine crashes?
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
