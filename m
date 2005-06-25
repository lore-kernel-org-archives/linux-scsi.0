From: Pavel Machek <pavel@ucw.cz>
Subject: Re: aic79xx -> can't  suspend
Date: Sat, 25 Jun 2005 06:01:52 +0200
Message-ID: <20050625040152.GG22393@atrey.karlin.mff.cuni.cz>
References: <1119549104.13259.1.camel@mindpipe> <20050623193224.GD2251@voodoo> <1119573142.20628.15.camel@mindpipe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38351 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S263316AbVFYEBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 00:01:55 -0400
Content-Disposition: inline
In-Reply-To: <1119573142.20628.15.camel@mindpipe>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Revell <rlrevell@joe-job.com>
Cc: Jim Crilly <jim@why.dont.jablowme.net>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

> On Thu, 2005-06-23 at 15:32 -0400, Jim Crilly wrote:
> > On 06/23/05 01:51:43PM -0400, Lee Revell wrote:
> > > I have a machine with an Adaptec 2940U2W adapter running 2.6.11.
> > > When I try to go into standby like so:
> > > 
> > >     echo standby > /sys/power/state
> > > 
> > > this is what happens:
> > 
> > AFAIK no SCSI drivers have had power management functions implemented,
> > a quick grep for PM_ in drivers/scsi seems to confirm that only the
> > PCMCIA SCSI drivers even look for PM events. 
> 
> Actually it is implemented in the aic7xxx driver, see ahc_suspend and
> ahc_resume.
> 
> I tried it with 2.6.12, and I no longer have the problem with the ahc_dv
> thread as it no longer exists (AFAICT the functionality is handled by
> the SCSI midlayer now?).
> 
> Now it just immediately resumes:
> 
> [4297399.286000] PM: Preparing system for standby sleep
> [4297399.609000] Stopping tasks: ================================|
> [4297399.610000] Restarting tasks... done
> 
> How can I debug this further?

Enable debugging in drivers/base/power/*...

								Pavel

-- 
Boycott Kodak -- for their patent abuse against Java.
