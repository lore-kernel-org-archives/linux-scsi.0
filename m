From: Spelic <spelic@shiftmail.org>
Subject: Re: on-off periodic hangs in scsi commands
Date: Thu, 06 Jan 2011 22:06:51 +0100
Message-ID: <4D262EEB.9070303@shiftmail.org>
References: <4D24BEC4.7040906@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.isti.cnr.it ([194.119.192.4]:4977 "EHLO mx2.isti.cnr.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab1AFVHi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 16:07:38 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWBHL90GKWNG87AL@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Thu, 06 Jan 2011 22:06:37 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWBHL8B5F4NG87AJ@mx.isti.cnr.it> for
 linux-scsi@vger.kernel.org; Thu, 06 Jan 2011 22:06:35 +0100 (MET)
In-reply-to: <4D24BEC4.7040906@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, scst-devel@lists.sourceforge.net

On 01/05/2011 07:56 PM, Spelic wrote:
> Hello
> I am on kernel 2.6.36.2  (but I think I saw this problem also long 
> time ago on 2.6.31)
> I am having problems of greatly reduced throughput to scsi devices
>
> ...with 3ware...
> ...and now with iscsi...

Please disregard the whole iSCSI thing, iSCSI works perfectly!
I forgot I had a firewall test running simultaneously, I'm just 
stupid... let's not even talk about it :-(



The 3ware thing is real though, but I guess it's some kind of 3ware bug. 
Difficult to say for sure until I can get my hands on another controller.
Strange thing only one MD array has that problem even though there are 
other similar MD raid5 arrays on the same controller and other identical 
controllers.
It can't be a damaged disk because writes get stuck cyclically on all 6 
drives of that array.
Even cables can't be: they are cables for 4 drives each, and 2 drives 
are together with other 2 drives on another MD array which doesn't show 
the problem.

Is there any way to tell Linux to poll a PCI device even if it hasn't 
received an interrupt from it?
If I could poll the controller every, say, 0.2 sec I could test if the 
problem goes away.

Thank you
