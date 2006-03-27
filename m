From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Sun, 26 Mar 2006 16:06:56 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603261602070.15714@g5.osdl.org>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
 <Pine.LNX.4.64.0603261424590.15714@g5.osdl.org> <Pine.LNX.4.61.0603270116150.15593@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:9374 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932231AbWC0AHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Mar 2006 19:07:09 -0500
In-Reply-To: <Pine.LNX.4.61.0603270116150.15593@yvahk01.tjqt.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On Mon, 27 Mar 2006, Jan Engelhardt wrote:
> 
> Ah. So all the minix, bsd and sun c?t?[dps]? naming is based on what then 
> (someone drinking just too much coffe?), if BTL/CTD/HCIL (call it what you 
> want) never existed?

Right. 

It was a stupid idea even in the 80's. It's only gotten stupider since.

Now, during the 80's it was at least _excusable_. It was reasonable to 
think that you can just enumerate the controllers. And it was simple, and 
since hotplug controllers back then was "operator plug", not the modern 
kind of "they magically show up", it worked and controller numbers _meant_ 
something (even though they'd change when you switched things around, but 
you can expect that).

These days, you just cannot enumerate controllers in any meaningful 
manner. I don't think you ever really could, but at least with static 
hardware, any random enumeration was as good as any other.

			Linus
