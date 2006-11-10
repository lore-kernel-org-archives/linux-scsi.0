From: Michael Stone <mstone@mathom.us>
Subject: Re: aic79xx dumping card state
Date: Fri, 10 Nov 2006 10:39:31 -0500
Message-ID: <20061110153929.GG2667@mathom.us>
References: <20061110004508.GF2667@mathom.us> <20061110150126.GA8222@npjaco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms042pub.verizon.net ([206.46.252.42]:22970 "EHLO
	vms042pub.verizon.net") by vger.kernel.org with ESMTP
	id S1161850AbWKJPjj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 10:39:39 -0500
Received: from osgiliath.mathom.us ([71.246.251.8])
 by vms042.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0J8I009JXU5YNYKA@vms042.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Fri, 10 Nov 2006 09:39:34 -0600 (CST)
In-reply-to: <20061110150126.GA8222@npjaco>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaco van der Schyff <jvds@netgroup.co.za>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 10, 2006 at 05:01:26PM +0200, Jaco van der Schyff wrote:
>I had very similar problems on the aic79xx cards.  What you could first
>check if QAS is enabled/disabled on both devices, 

How do you tell that? Is it something readable from the kernel, or do I 
have to poke around on the devices?

>and step the card down
>to 160MB/s.  I haven't successfully ran any aic79xx Ultra320 card at
>Ultra320...
>
>Clock it down and it should be fine...

Yikes, that's not a solution. :) I found the aic79xx=slowcrc option and 
enabled that, and I've been running pretty solid at 320 (~300MBps 
transfer rates). I'll pound on it over the weekend and see if it stays 
solid.

Mike Stone
