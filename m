From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: device_suspend() levels [was Re: [patch] ACPI work on aic7xxx]
Date: Tue, 20 Jul 2004 14:25:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090347939.1993.7.camel@gaston>
References: <40FD38A0.3000603@optonline.net>
	 <20040720155928.GC10921@atrey.karlin.mff.cuni.cz>
	 <40FD4CFA.6070603@optonline.net>
	 <20040720174611.GI10921@atrey.karlin.mff.cuni.cz>
	 <40FD6002.4070206@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:32421 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S266114AbUGTS1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 14:27:52 -0400
In-Reply-To: <40FD6002.4070206@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: Pavel Machek <pavel@suse.cz>, linux-scsi@vger.kernel.org, random1@o-o.yi.org, Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel list <linux-kernel@vger.kernel.org>


> Seems to me, aside from whether it's an enum or not, it should represent 
> a D-state not an ACPI S-state. Some platforms (Power Mac?) probably 
> implement PCI power management but not in an ACPI way.

2 comments here:

 - The low level bus state (PCI D state for example) and the "linux"
state should be 2 different entities.

 - For PCI, we probably want a hook so the arch can implement it's own
version of pci_set_power_state() so that ACPI can use it's own trickery
there.

Ben.


