From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Why REPORT LUN only for SCSI-2?
Date: Thu, 17 Jul 2003 16:46:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717164642.A9253@beaverton.ibm.com>
References: <3F140D30.D2B5C4D8@fujitsu-siemens.com> <20030715073927.A8218@beaverton.ibm.com> <3F14F7FA.BA551505@fujitsu-siemens.com> <20030716123519.A19244@beaverton.ibm.com> <3F16649C.239EC87B@fujitsu-siemens.com> <20030717184909.GD2520@nbkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:17892 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S271635AbTGQXbr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 19:31:47 -0400
Content-Disposition: inline
In-Reply-To: <20030717184909.GD2520@nbkurt.garloff.de>; from garloff@suse.de on Thu, Jul 17, 2003 at 08:49:09PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, =?iso-8859-1?Q?Josef_M=F6llers?= <josef.moellers@fujitsu-siemens.com>, linux-scsi@vger.kernel.org, "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>

On Thu, Jul 17, 2003 at 08:49:09PM +0200, Kurt Garloff wrote:

> > As a side note (probably starting a new thread) why does BLIST_LARGELUN
> > override max_scsi_luns? 
> 
> It shouldn't. Did I really do this? (... checking 2.4 code ...)
> No, I plead innocent.
> 
> > If I specify on the command line that I want
> > only 8 LUNs, I want only 8 LUNs and BLIST_LARGELUN overrides this with
> > the HA's max_lun.
> 
> Sure. If I don't misparse the code, this should work in 2.4.

The code looks right in 2.6 also - if SCSI-3 or BLIST_LARGELUN, we use the
min of max_lun and max_scsi_luns; else (SCSI-2 and not large lun) the min
of 8, max_lun, and max_scsi_luns.

-- Patrick Mansfield
