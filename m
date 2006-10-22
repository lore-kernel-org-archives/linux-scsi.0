From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Sat, 21 Oct 2006 21:45:03 -0700
Message-ID: <1161492303.3204.75.camel@home-desk>
References: <1161210246.3204.17.camel@home-desk>
	 <1161210748.3204.22.camel@home-desk>  <1161237121.15090.9.camel@max>
	 <1161260730.3204.36.camel@home-desk>  <45378767.4080106@suse.de>
	 <1161274711.3204.41.camel@home-desk>  <45387462.10300@suse.de>
	 <1161463732.3204.66.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:26033 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1422914AbWJVEpK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Oct 2006 00:45:10 -0400
In-Reply-To: <1161463732.3204.66.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org


> I spent some time to whack together a SCSI target on a second machine
> with a QLA1040 that I have lying around and connected my test machine
> with the 29320 to it. Essentially, I'm just too lazy to sit at my desk
> an continually disconnect and reconnect the power on my array!  :)
> 
> After a couple of minutes of whacking on it, I was able to script
> something to automatically cycle through 5 iterations of 'mkfs' then
> reboot the new 'scsi disk', sleep for 120 seconds and repeat.
> 
> Seems to work fine with the patch applied to 2.6.19-rc2.  I'm running a
> longer 100 iteration loop and I'll get back with results.
> 


Nice.  I ran a 100 loop test with zero errors.  

Sean

