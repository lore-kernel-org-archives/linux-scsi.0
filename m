From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Fri, 30 Sep 2005 12:47:20 -0400
Message-ID: <433D6C18.2070202@adaptec.com>
References: <20050929232013.95117.qmail@web31810.mail.mud.yahoo.com>	 <Pine.LNX.4.64.0509291730360.3378@g5.osdl.org>	 <433CE961.3040504@torque.net> <1128097576.10079.88.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15505 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030369AbVI3Qr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 12:47:27 -0400
In-Reply-To: <1128097576.10079.88.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.patterson@hp.com
Cc: dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 09/30/05 12:26, Andrew Patterson wrote:
> 
> I talked to one of the authors of these specs.  SDI is an attempt to
> create an open standard for the somewhat proprietary CSMI spec developed
> by HP.  It is currently languishing in t10 due to the IOCTL problem you
> describe below (the "no new IOCTL's" doctrine caught them by surprise).
> There is some thought to going to a write()/read() on a character device
> model, but this has various problems as well.  

I think that read/write from a char device is going away too.

For this reason I showed the whole picture of the SAS
domain in sysfs _and_ created a binary file attr to
send/receive SMP requests/responses to control
the domain and get attributes ("smp_portal" binary
attr of each expander).

It is completely user space driven and a user space library
is simple to write.

See drivers/scsi/sas/expander_conf.c which is a user
space utility.  For the output see Announcement 3:
http://linux.adaptec.com/sas/Announce_2.txt or here:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509318354&w=2

The code which implements it is very tiny, at the bottom
of drivers/scsi/sas/sas_expander.c

>>Sorry, did I mention "ioctl",
>>oh that makes SDI unacceptable. Almost a year ago that is what
>>happened to the first proposed SAS driver for Linux. 
> 
> 
> That was one of the reasons the MPT Fusion and Adaptec drivers were
> rejected.  There were others as well, such as lack of a SAS transport
> class.

You mean the first Adaptec SAS "adp94xx" driver.

BTW, neither the original "adp94xx", nor the subsequent "aic94xx"
Adaptec drivers implmented _any_ ioctls for CSMI/SDI.

	Luben



