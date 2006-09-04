From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Open for adoption: orphan sbp2_target
Date: Mon, 04 Sep 2006 11:03:16 +0200
Message-ID: <44FBEBD4.6070606@s5r6.in-berlin.de>
References: <5b45756a0608141057s6c00d7cfu388d9d342c5e936d@mail.gmail.com>	<44ED996A.4010009@s5r6.in-berlin.de> <200608260448.k7Q4m8rq019092@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:11224 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1751356AbWIDKZ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Sep 2006 06:25:59 -0400
In-Reply-To: <200608260448.k7Q4m8rq019092@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hani.mustafa@gmail.com, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, tomof@acm.org, michaelc@cs.wisc.edu

FUJITA Tomonori wrote on 2006-08-26:
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
...
>> Could someone of the SCSI target folks give a rough outline of a SCSI
>> target's building blocks when using this framework?
> 
> Our OLS's paper and slides have good pictures.
> 
> http://stgt.berlios.de/
> 
> I guess that SBP target stuff works well with the target
> framework. All you need to do is to take care of SBP protocol. The
> framework does the rest, that is, SCSI protocol processing, I/O,
> logical unit management, configuration, etc.
> 
> For example, your driver receives a SCSI command from an initiator,
> tell the framework to perform it. Then the framework sends back the
> result and buffer containing data you send to the initiator if
> necessary.

This looks very comfortable to write a transport driver against.

> I don't know where your driver is implemented, in kernel space or user
> space.

Hani Mustafa's unpublished target is in kernel, Manish Singh's in
userspace (as a libraw1394 application via the raw1394 character device;
AFAIU multiple initiators capable, currently single-LU and only RBC
implemented).

>From end-user perspective, userspace might be preferable. I don't know
though what the performance implications are and how easy e.g. optical
drives could be integrated one or the other way. However, choices are
good. (Besides and off topic, an SBP-2 target implementation in BIOS
would be useful, like in Apple's firmware of their desktops and portables.)

> The framework was designed for the former, however, it works
> with both models now. You can find an example of the latter (though
> it's just experiment):
> 
> svn co http://svn.berlios.de/svnroot/repos/stgt/branches/user-iscsi
> 
> 
> BTW, we've prepared a new git tree:
> 
> http://www.kernel.org/git/?p=linux/kernel/git/mnc/linux-2.6-target.git;a=summary

Thanks for the explanation and links.

BTW, why not write the source file names out as _target_ instead of
_tgt_? I hear git supports file renaming... :-)
-- 
Stefan Richter
-=====-=-==- =--= --=--
http://arcgraph.de/sr/

-- 
VGER BF report: H 4.53233e-10
