From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: /dev/hd* in sg_scan
Date: 29 Oct 2003 10:16:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067447763.13824.26.camel@patehci2>
References: <1067299763.3469.6.camel@patehci2> <3F9F4393.5060602@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:27010 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261152AbTJ2RQN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 12:16:13 -0500
In-Reply-To: <3F9F4393.5060602@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> Sg3_utils' sg_map and sg_scan for lk 2.6 still have me
> thinking ... waiting ...
> sg .. to use cdevs (char ... sysfs ... > 256 minors)
> latest freeze ... scsi tape robots and enclosures ...

Prompt & cogent as usual, thank you.

> >http://tldp.org/HOWTO/SCSI-Generic-HOWTO/open.html
> > >... O_NONBLOCK ... ignored by ioctl(SG_IO)
> > 
> > As of 2.6, in fact we now need O_NONBLOCK if we want open O_RDONLY to
> > let us talk SG_IO to a DVD/CD with no disk present?  Also we discard the
> > history of passing thru less commands for O_RDONLY than for O_RDWR?

I guess, but I do not know.

> With either /dev/hd and /dev/sd ...

Thanks for hinting at /dev/sd$v or /dev/sd$v$n.

I see /dev/scd$n rejects SG_IO.

So far I have only seen /dev/hd$v and /dev/sg$n work.

> With either /dev/hd and /dev/sd you may soon want to find
> out (or probe) before making any assumptions:
>    - what protocol are you using (e.g. ATA, ATAPI, SCSI)
>    - what transport (e.g. pATA, sATA, SPI, FC, USB, SAS)

I see you hint darkly ... at what I do not know.

Why am I going to want to discover protocol & transport?

How will I do so?

> currently I'm rewriting sginfo).

Thank you.

I trust you won't let me slow you down with my ignorant questions.

Pat LaVarre


