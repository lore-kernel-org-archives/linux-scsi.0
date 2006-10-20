From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Subject: RE: Mid-layer API?
Date: Fri, 20 Oct 2006 10:32:21 -0500
Message-ID: <861B5CF71BC70C478DFEB9EAFE98F699ACA42C@G3W0068.americas.hpqcorp.net>
References: <20061020080617.30483.qmail@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:5274 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S1946131AbWJTPcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2006 11:32:42 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20061020080617.30483.qmail@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com, linux-scsi@vger.kernel.org

Hi Luben,

> The answer to your question depends on the answer to this
> question: Who is generating the commands and data, or loosely 
> where are the commands and data coming from?

I'm using the Linux box as a 'dumb' SCSI adapter. The SCSI commands are
received by a driver that manages a proprietary interface through which
the commands are coming in from a remote host. The driver then needs to
forward the commands to the FC disk (by means I'm trying to figure out
here :-) and pass the results back up to the host. 
 
> Once you've answered this, then you can take a look at who 
> (or what) is the midlayer servicing.  Sketch that on paper.
> 
> Then chart on another sheet of paper the complete path of the 
> commands and data,  from the origin to the point you want to "send"
> them to the FC disk and compare that the above chart.

I guess my biggest problem is that I don't fully understand the flow of
command and data through the different layers. I could instrument a
kernel to dump some tracing information but that sounds like a lot of
work. Might be worth though to gain a better understanding.

> This will give you the answer of where you're supposed to 
> "hook into" and why.

Not quiet there yet :-) 

Thanks for your help
...juerg


> Good luck!
>     Luben
> 
> 
> > And finally, is there any
> > documentation talking about the mid-layer API?
> > 
> > Any help is greatly appreciated.
> > 
> > Thanks
> > ...juerg
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" 
> > in the body of a message to majordomo@vger.kernel.org More 
> majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
