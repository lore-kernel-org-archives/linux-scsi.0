From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Kernel crash with AIC94xx (one step forward, hope it's lucky)
Date: Thu, 26 Apr 2007 02:39:23 -0700 (PDT)
Message-ID: <133536.33882.qm@web31804.mail.mud.yahoo.com>
References: <1177442456.6284.75.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:30021 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161809AbXDZJjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 05:39:24 -0400
In-Reply-To: <1177442456.6284.75.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, brailateo@gmail.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:

> Please don't cut linux-scsi from the cc list
> 
> On Tue, 2007-04-24 at 22:14 +0300, Constantin Teodorescu wrote:
> > James Bottomley wrote:
> > > This configuration doesn't work on the vanilla linux kernel ... you need
> > > the scsi-aic94xxx-sas-2.6 tree as well for this; is that what you're
> > > running with?
> > >   
> > Yes, I am experimenting now on a 2.6.21-RC7 kernel with 1.0.3 version of 
> > aic94xx driver.
> > 
> > > Are these SAS or SATA drives?
> > >   
> > 8 SAS drives
> > 
> > I have already received some information from Luben Tuikov and Alexis 
> > Bruemmer (he told me that there is a new firmware seq file at Adaptec) 
> > and I am sending you the message:
> > 
> > Luben Tuikov wrote:
> > > Constantin,
> > >
> > > adp94xx is not supported by anyone.
> > >
> > > The in-kernel aic94xx is supported by linux-scsi mailing list
> > > and your OS vendor.
> > >
> > >     Luben
> > >   

Having said that, I still support the original version
of the aic94xx and the SAS stack, which now includes
SAT-1 conformant SATL.

It has allowed some people to upgrade their kernels to
the latest kernel version (as in from git repo), and reported that
it is more stable (i.e. working as opposed to not, including
supporting SATA devices in SAS domains) than the in-kernel version.

It also keeps the sequencer fw together with the driver source
code, so the end-user wouldn't have to mix and match fw version
with driver (kernel) version.

   Luben

> > I was afraid of ... :-(
> > 
> > I already got the news from Andy Warner that told me about that !
> > 
> > Alexis Bruemmer send me also a message saying :
> > > Yep we have seen this issue before.  However the fix involves both a
> > > driver update and a sequencer f/w update found at:
> > >
> > >
>
http://www.adaptec.com/en-US/downloads/linux_source/linux_source_code?productId=SAS-48300&dn=Adaptec+Serial+Attached+SCSI+48300
> 
> > >
> > >
> > > If you still get this crash with that version of the sequencer let me
> > > know
> > 
> > Digging I discovered that the firmware is different (md5sum differs) and 
> > newer (released in 2 Mar 2007) that the firmware that I installed in 
> > January 2007.
> > 
> > bnd:~/# md5sum /lib/firmware/aic94xx-seq.fw old-aic94xx-seq.fw
> > fb393f52fde81eb53afa1e204a606c37  /lib/firmware/aic94xx-seq.fw
> > 589f442b43ea0cc42fec275d7a612c2e  old-aic94xx-seq.fw
> > 
> > So I downloaded the new firmware and I will intensively teste it.
> > I will keep you informed about the results.
> > 
> > Thank you again for all your valuable help,
> > Best regards from Romania,
> > Teo
> > 
> > 
> > 
> > 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

