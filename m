From: Evan Felix <evan.felix@pnl.gov>
Subject: Re: HSV : ghosts & multipath
Date: Tue, 12 Aug 2003 08:52:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060703573.5430.9.camel@e-linux>
References: <3F3820C9.4060004@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlas.pnl.gov ([130.20.248.194]:49559 "EHLO atlas.pnl.gov")
	by vger.kernel.org with ESMTP id S270648AbTHLPsP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 11:48:15 -0400
Received: from vscan2.pnl.gov ([130.20.64.141]) by pnl.gov (PMDF V6.1-1 #30581)
 with SMTP id <0HJI00A2FJWEOZ@pnl.gov> for linux-scsi@vger.kernel.org; Tue,
 12 Aug 2003 08:48:14 -0700 (PDT)
In-reply-to: <3F3820C9.4060004@free.fr>
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: linux-scsi@vger.kernel.org

The HSV Ghost LUNS can be made active by sending the Start Unit Command
down the scsi path.  I have not had time to attempt to use this command,
and am not sure it can be sent to a Linux scsi device that is showing
'Not Ready'(Sense Code) and 'Not Connected'(Inquiry).  Other on this
list may be able to help us in this area.  Once you send this command
down, you will need to wait some amount of time while it flushes IO's
and changes controllers.

If you get this working i would love to see the results.

Evan


On Mon, 2003-08-11 at 16:03, christophe varoqui wrote:
> Hello,
> 
> I read your contribution to scsidev, regarding HSV.
> You seem to have an intimate knowledge of these controlers.
> Do you happen to have a clue on how to force the activation of a ghost 
> LUN from a Linux host ?
> 
> The rationale being : in a multipath config, when all active path are 
> exhausted you should be able to activate the ghosts paths rather than 
> let the device die.
> 
> More generally, how do you manage access to your HSV LUNs ? I personnaly 
> would hate to use SecurePath which locks the user to one distribution 
> and has not passed the "community peer-review test". Any alternative 
> applicable in a dual fabric, dual attached hosts & controlers (4 
> paths/host including 2 ghosts : 2 paths through the left fabric, 2 paths 
> through the right) ?
-- 
-------------------------
Evan Felix
Environmental Molecular Sciences Laboratory
Pacific Northwest National Laboratory
Operated for the U.S. DOE by Battelle

