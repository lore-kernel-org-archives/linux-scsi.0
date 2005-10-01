From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Fri, 30 Sep 2005 20:02:14 -0400
Message-ID: <433DD206.1060802@pobox.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01A9FA11@otce2k03.adaptec.com> <1128105594.10079.109.camel@bluto.andrew> <433D9035.6000504@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:2953 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030511AbVJAACT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 20:02:19 -0400
In-Reply-To: <433D9035.6000504@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: andrew.patterson@hp.com, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Luben Tuikov wrote:
> But you can write a user space library which uses sysfs or whatever
> _that_ OS uses to represent an SDI spec-ed out picture.
> 
> So a user space program would call (uniformly across all OSs)
> a libsdi library which will use whatever OS dependent way there is
> to get the information (be it sysfs or ioctl).

Agreed completely :)

	Jeff


