From: Doug Ledford <dledford@redhat.com>
Subject: Re: aic7xxx 6.2.24 bug report
Date: Sun, 29 Dec 2002 14:07:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021229140737.I29061@redhat.com>
References: <20021228204505.GC9319@linnie.riede.org> <766648112.1041108533@aslan.scsiguy.com> <20021228222620.GE9319@linnie.riede.org> <834928112.1041114482@aslan.scsiguy.com> <20021228232624.GG9319@linnie.riede.org> <910548112.1041122117@aslan.scsiguy.com> <20021229015759.GI9319@linnie.riede.org> <3E0E5E2F.9030403@torque.net> <20021229141729.GK9319@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021229141729.GK9319@linnie.riede.org>; from wrlk@riede.org on Sun, Dec 29, 2002 at 09:17:29AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Sun, Dec 29, 2002 at 09:17:29AM -0500, Willem Riede wrote:
> 
> Red Hat nash version 3.4.28 starting
> 
> it's from their 8.0 release.

I'm not sure, but it could be.  I think the current initrd still uses the 
available insmod instead of trying to do the syscalls internally, so that 
shouldn't be a problem.  But, nash doesn't do command line arguments 
exactly identical to bash so I had to play with the command line argument 
escaping in the past to get it to work right in nash.  But, try adding 
ash.static to your initrd, then as the last line in linuxrc call 
ash.static and it will drop you to a shell prompt where you can attempt to 
perform the insmod by hand and see if you can get it to work before the 
kernel panics for lack of a root device.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
