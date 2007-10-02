From: Pavel Machek <pavel@ucw.cz>
Subject: Re: kdump detection in SCSI drivers
Date: Tue, 2 Oct 2007 10:00:03 +0200
Message-ID: <20071002080000.GA5743@atrey.karlin.mff.cuni.cz>
References: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com> <20070920104249.GB12157@atrey.karlin.mff.cuni.cz> <9738BCBE884FDB42801FAD8A7769C26501B2C7D8@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756157AbXJBIA0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501B2C7D8@NAMAIL1.ad.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi!

> How do we "know" when little memory is available?

Kernel already scales its hash tables according to total RAM
available, perhaps you can use similar mechanism?

> Other suggestion which came about was to parse the kernel command line
> and look for "elfcorehdr=". Is this ok? Is kernel command line visible
> to the SCSI drivers?

Kernel command line probably is visible, but I'd recommend against
doing that.

							Pavel

> Cc: Linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: kdump detection in SCSI drivers
> 
> > Hi,
> > 
> > Is there a standard way for drivers (RAID) to detect if the current
> > kernel is running in kdump mode? We would like to adjust driver
> behavior
> > dynamically when kdump is active by scaling down resources.
> 
> Perhaps you should be automatically using little resources when little
> memory is available, or something? 
> 
> With upcomping kjump patches, it is more "interesting" than kdump
> vs. no kdump.
> 	
> Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
