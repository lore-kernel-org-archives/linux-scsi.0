From: christophe.varoqui@free.fr
Subject: Re: HSV : ghosts & multipath
Date: Wed, 13 Aug 2003 13:53:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060775593.3f3a26a967f2d@impt3-2.free.fr>
References: <3F3820C9.4060004@free.fr> <1060703573.5430.9.camel@e-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:8072 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S271129AbTHMLxP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 07:53:15 -0400
In-Reply-To: <1060703573.5430.9.camel@e-linux>
List-Id: linux-scsi@vger.kernel.org
To: Evan Felix <evan.felix@pnl.gov>
Cc: linux-scsi@vger.kernel.org

Hello,

sg_start, which comes with latest sg3_utils, does the trick, indeed.
Thanks for the tip.

Selon Evan Felix <evan.felix@pnl.gov>:

> The HSV Ghost LUNS can be made active by sending the Start Unit Command
> down the scsi path.  I have not had time to attempt to use this command,
> and am not sure it can be sent to a Linux scsi device that is showing
> 'Not Ready'(Sense Code) and 'Not Connected'(Inquiry).  Other on this
> list may be able to help us in this area.  Once you send this command
> down, you will need to wait some amount of time while it flushes IO's
> and changes controllers.
> 
> If you get this working i would love to see the results.
> 
> Evan
> 
> 
> On Mon, 2003-08-11 at 16:03, christophe varoqui wrote:
> > Hello,
> > 
> > I read your contribution to scsidev, regarding HSV.
> > You seem to have an intimate knowledge of these controlers.
> > Do you happen to have a clue on how to force the activation of a ghost 
> > LUN from a Linux host ?
> > 
> > The rationale being : in a multipath config, when all active path are 
> > exhausted you should be able to activate the ghosts paths rather than 
> > let the device die.
> > 
> > More generally, how do you manage access to your HSV LUNs ? I personnaly 
> > would hate to use SecurePath which locks the user to one distribution 
> > and has not passed the "community peer-review test". Any alternative 
> > applicable in a dual fabric, dual attached hosts & controlers (4 
> > paths/host including 2 ghosts : 2 paths through the left fabric, 2 paths 
> > through the right) ?
> -- 
> -------------------------
> Evan Felix
> Environmental Molecular Sciences Laboratory
> Pacific Northwest National Laboratory
> Operated for the U.S. DOE by Battelle
> 
> 


-- 
