From: "Jaco van der Schyff" <jvds@netgroup.co.za>
Subject: Re: aic79xx dumping card state
Date: Fri, 10 Nov 2006 19:09:14 +0200 (SAST)
Message-ID: <36021.196.2.124.251.1163178554.squirrel@webmail.netgroup.co.za>
References: <20061110004508.GF2667@mathom.us> <20061110150126.GA8222@npjaco>
    <20061110153929.GG2667@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netgroup.co.za ([196.25.213.80]:54734 "EHLO
	mail.netgroup.co.za") by vger.kernel.org with ESMTP
	id S1161319AbWKJRHg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 12:07:36 -0500
In-Reply-To: <20061110153929.GG2667@mathom.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stone <mstone@mathom.us>
Cc: Jaco van der Schyff <jvds@netgroup.co.za>, linux-scsi@vger.kernel.org

> On Fri, Nov 10, 2006 at 05:01:26PM +0200, Jaco van der Schyff wrote:
>>I had very similar problems on the aic79xx cards.  What you could first
>>check if QAS is enabled/disabled on both devices,
>
> How do you tell that? Is it something readable from the kernel, or do I
> have to poke around on the devices?

Yes on the devices, you will be able to see the settings of the card in
the scsi select util at bootup.  Check the manuals of the devices you
connect to the scsi bus for their settings.

>>and step the card down
>>to 160MB/s.  I haven't successfully ran any aic79xx Ultra320 card at
>>Ultra320...
>>
>>Clock it down and it should be fine...
>
> Yikes, that's not a solution. :) I found the aic79xx=slowcrc option and
> enabled that, and I've been running pretty solid at 320 (~300MBps
> transfer rates). I'll pound on it over the weekend and see if it stays
> solid.

Cool! slowcrc didn't work for me... :(

- Jaco van der Schyff


