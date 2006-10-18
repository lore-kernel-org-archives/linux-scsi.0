From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] ALUA support for scsi_debug
Date: Wed, 18 Oct 2006 13:11:06 -0400
Message-ID: <4536602A.5050008@torque.net>
References: <20061018145018.GC25084@pentland.suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45549 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422703AbWJRRJl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 13:09:41 -0400
In-Reply-To: <20061018145018.GC25084@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Hi all,
> 
> I've hacked up scsi_debug to support REPORT TARGET PORT GROUPS.
> In combination with vpd_use_hostno=0 it'll now support multipathing
> nicely.
> Doug, there is reference to port_a and port_b in the VPD page support.
> However, port_b appearently is just a fake entry with no (virtual)
> device backing.

Hannes,
Yes, I was mimicking a SAS drive with the secondary port
unconnected.

> We could eg use the 'channel' value to refer the relative port number,
> so that host & channel act as a fan-out for multipathing.

I'll have a look, perhaps it could be wired when
vpd_use_hostno=0 .

> James, please apply.

Umm, I would like to find out why that patch oopses
my machine when I load the scsi_debug module.

lk 2.6.19-rc2 has regressed in a few areas, for example
after an oops, inane messages from atkbd repeat ad
nauseum, making the oops hard to analyse. And my SMC2835W
(prism54 driver) no longer works.

Doug Gilbert

