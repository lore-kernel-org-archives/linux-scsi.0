From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: device_suspend() levels [was Re: [patch] ACPI work on aic7xxx]
Date: Tue, 27 Jul 2004 21:18:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090977479.2006.30.camel@gaston>
References: <Pine.LNX.4.10.10407260026590.1977-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:39130 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S266752AbUG1BYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 21:24:18 -0400
In-Reply-To: <Pine.LNX.4.10.10407260026590.1977-100000@master.linux-ide.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: Nathan Bryant <nbryant@optonline.net>, linux-scsi@vger.kernel.org, Pavel Machek <pavel@ucw.cz>

On Mon, 2004-07-26 at 03:32, Andre Hedrick wrote:
> Ben,
> 
> Remember to prevent suspend "BRAIN DAMAGE", scsi has host-hba
> dma-queue-rings to manage.  I have thought about this for a while and have
> considered a glass of scotch or two ease the pain.
> 
> SCSI != IDE
> 
> IDE is a simple child by comparison.
> 
> SCSI is painful because the hardware specifically prevents raw low-level
> access to the bus-phase.

Hi Andre !

That shouldn't be a problem in our case though, but the scsi layer more
complicated command queuing mecanism is...

Ben.


