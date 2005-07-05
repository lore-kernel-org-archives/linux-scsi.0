From: Chris Wright <chrisw@osdl.org>
Subject: Re: WARNING : kernel 2.6.11.7 (others) kills megaraid 4e/Si dead
Date: Tue, 5 Jul 2005 08:58:09 -0700
Message-ID: <20050705155808.GI9153@shell0.pdx.osdl.net>
References: <20050503151532.GA1316@thumper2> <20050503190005.GS23013@shell0.pdx.osdl.net> <42CA9E93.1050802@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261909AbVGEQPU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42CA9E93.1050802@mandriva.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Backlund <tmb@mandriva.org>
Cc: Chris Wright <chrisw@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy <genanr@emsphone.com>
List-Id: linux-scsi@vger.kernel.org

* Thomas Backlund (tmb@mandriva.org) wrote:
> Chris Wright wrote:
> >* Andy (genanr@emsphone.com) wrote:
> >
> >>cross posted due to the severity of this issue.
> >>
> >>I have killed two Dell 1850 (x86_64) with megaraid 4e/SI servers using
> >>kernel 2.6.11.7.  When the system boots, it looks like it does not see the
> >>megaraid controller (because it never prints anything about it) and hangs
> >>when it tries to mount root.  When rebooted, the system says no firmware
> >>present for embedded raid controller.  I then try to flash it, the flash
> >>program says the firmware is corrupt and flashes the controller.  However,
> >>upon reboot I still get the no firmware present, thus the machine can no
> >>longer boot off the raid.
> >
> >
> >Not good.  There were no megaraid changes in the -stable series.  What's
> >the last kernel.org kernel that worked for you?
> 
> Any news on this matter?
> I hvr a PE1850 waiting for kernel upgrade, but I'm afraid to do so now...
> 
> I can't break my box with tests since it's in active use...
> For now I'm running a 2.6.8.1 based kernel on the box...

Last known good one (that Andy tested) was 2.6.10.  His was the only
report I've seen, and I haven't found any more details on it.
