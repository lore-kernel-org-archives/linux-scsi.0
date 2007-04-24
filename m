From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Kernel crash with AIC94xx (one step forward, hope it's lucky)
Date: Tue, 24 Apr 2007 15:20:56 -0400
Message-ID: <1177442456.6284.75.camel@mulgrave.il.steeleye.com>
References: <462DC53D.6060108@gmail.com>
	 <1177439876.6284.73.camel@mulgrave.il.steeleye.com>
	 <462E5732.8020408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57352 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423040AbXDXTVC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2007 15:21:02 -0400
In-Reply-To: <462E5732.8020408@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brailateo@gmail.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Please don't cut linux-scsi from the cc list

On Tue, 2007-04-24 at 22:14 +0300, Constantin Teodorescu wrote:
> James Bottomley wrote:
> > This configuration doesn't work on the vanilla linux kernel ... you need
> > the scsi-aic94xxx-sas-2.6 tree as well for this; is that what you're
> > running with?
> >   
> Yes, I am experimenting now on a 2.6.21-RC7 kernel with 1.0.3 version of 
> aic94xx driver.
> 
> > Are these SAS or SATA drives?
> >   
> 8 SAS drives
> 
> I have already received some information from Luben Tuikov and Alexis 
> Bruemmer (he told me that there is a new firmware seq file at Adaptec) 
> and I am sending you the message:
> 
> Luben Tuikov wrote:
> > Constantin,
> >
> > adp94xx is not supported by anyone.
> >
> > The in-kernel aic94xx is supported by linux-scsi mailing list
> > and your OS vendor.
> >
> >     Luben
> >   
> I was afraid of ... :-(
> 
> I already got the news from Andy Warner that told me about that !
> 
> Alexis Bruemmer send me also a message saying :
> > Yep we have seen this issue before.  However the fix involves both a
> > driver update and a sequencer f/w update found at:
> >
> > http://www.adaptec.com/en-US/downloads/linux_source/linux_source_code?productId=SAS-48300&dn=Adaptec+Serial+Attached+SCSI+48300 
> >
> >
> > If you still get this crash with that version of the sequencer let me
> > know
> 
> Digging I discovered that the firmware is different (md5sum differs) and 
> newer (released in 2 Mar 2007) that the firmware that I installed in 
> January 2007.
> 
> bnd:~/# md5sum /lib/firmware/aic94xx-seq.fw old-aic94xx-seq.fw
> fb393f52fde81eb53afa1e204a606c37  /lib/firmware/aic94xx-seq.fw
> 589f442b43ea0cc42fec275d7a612c2e  old-aic94xx-seq.fw
> 
> So I downloaded the new firmware and I will intensively teste it.
> I will keep you informed about the results.
> 
> Thank you again for all your valuable help,
> Best regards from Romania,
> Teo
> 
> 
> 
> 

