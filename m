From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH 1/3] PM / Runtime: Update documentation of interactions
 with system sleep
Date: Sun, 26 Jun 2011 00:58:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1106260055270.23991@swampdragon.chaosbits.net>
References: <201106260054.20578.rjw@sisk.pl> <201106260055.09150.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19159 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1FYXHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jun 2011 19:07:41 -0400
In-Reply-To: <201106260055.09150.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org

On Sun, 26 Jun 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 

A few tiny nit-picks..

> The documents describing the interactions between runtime PM and
> system sleep generally refer to the model in which the system sleep
> state is entered through a global firmware or hardware operation.
> As a result, some recommendations given in there are not entirely
> suitable for systems in which this is not the case.  Update the
> documentation take the existence of those systems into accout.
> 

I believe this should read "... documentation to take the existence of 
those systems ..."


<...>
>  
> +On some systems, however, system sleep is not entered through a global firmware
> +or hardware operation.  Instead, all hardware components are put into low-power
> +states directly by the kernel in a coordinated way.  Then, the system sleep
> +state effectively follows from the states the hardware components end up in
> +and the system is woken up from that state by a hardware interrupt or a similar
> +mechanism entirely under the kernel's control.  As a result, the kernel never
> +gives control away and the states of all devices during resume are precisely
> +known to it.  If that is the case and none of the situations listed above takes
> +place (in particular, if the system is not waking up from hibernation), it may
> +be more efficient to leave the devices that had been suspended before the system
> +suspend began in the suspended state.
> +

You are refering to device*s*, so I believe this last bit should be "... 
in the suspended states".

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

