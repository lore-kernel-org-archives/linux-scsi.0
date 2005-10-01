From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Fri, 30 Sep 2005 20:01:39 -0400
Message-ID: <433DD1E3.2080606@pobox.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01A9FA11@otce2k03.adaptec.com> <1128105594.10079.109.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:137 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030509AbVJAABw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 20:01:52 -0400
In-Reply-To: <1128105594.10079.109.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.patterson@hp.com
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, "Tuikov, Luben" <Luben_Tuikov@adaptec.com>, dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Andrew Patterson wrote:
> SDI is supposed to be a cross-platform spec, so mandating sysfs would
> not work.  I suggested to the author to use a library like HPAAPI (used
> by Fibre channel), so you could hide OS implementation details.  I am in
> fact working on such a beasty (http://libsdi.berlios.de).  He thinks
> that library solutions tend to not work, because the library version is
> never in synch with the standard/LLDD's. Given Linux vendor lead-times,
> he does have a valid point.

Any kernel interface lib should be like libc or libalsa:  it hides the 
kernel details, however nasty they may be, shielding userspace and apps 
from various changes over time.

	Jeff


