From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Serial Attached SCSI Driver Interface (SDI)
Date: Mon, 15 Nov 2004 15:00:20 -0500
Message-ID: <41990AD4.1060900@adaptec.com>
References: <60807403EABEB443939A5A7AA8A7458B5C0F3D@otce2k01.adaptec.com> <4198EF00.2010305@pobox.com> <4198F579.9080606@adaptec.com> <4198FA4D.3000206@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:18880 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261652AbUKOUAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 15:00:39 -0500
In-Reply-To: <4198FA4D.3000206@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric.Moore@lsil.com

Jeff Garzik wrote:
> Please don't misunderstand.  I certainly agree that a management 
> infrastructure is needed, and yes, having a common one is preferred to 
> having a different one in each driver.
> 
> I however disagree that this commonality can be factored out by 
> committee (specification) that has no knowledge of Linux.  The motto of 
> Linux is, "do what you must, and no more."  If you look at the history 
> of Linux, _any_ time an API has been imposed upon Linux, inherent API 
> disconnects appear almost immediately.
> 
> I would much rather see a sysfs interface (transport class like James is 
> proposing) that specifies "knobs" (controls) needed under Linux... 
> controls that are presumably not redundant to a pre-existing Linux 
> knobs.  If you need 2.4.x compatibility, a driver can easily interface 
> with a common 2.4.x "libfs" filesystem module.
> 
> This applies whether we are talking about RAID management or storage 
> network management or SATA/SAS phy management.  Create a _Linux_ 
> management interface that is common across vendors and drivers.
> 
> T10, SNIA, and all the other storage industry committees have a _zero_ 
> percent track record for doing OS software APIs correctly.
> 
> Commonality: good.  API imposed upon Linux by non-Linux committee:  bad.
> 
> You can't write a Linux API without knowing Linux-related issues.

Hey Jeff,

I completely agree with you.  Minimalistic approach is a good thing.

As to the API: the more reason for knowlegable Linux folks to keep
an "eye" on SDI and other relevant developing standards.
This way there'd be yet another voice of experience (Linux).

Getting the design right is very important.  IMO, I think it'd
better to have OS independence (SDI) as opposed to "Windows, Linux
and other OSs are addressed" (pre-SDI).

I can envision a complete SAS domain representation somewhere
behind /sys, including phys, expanders and devices, all based
upon SDI, transparent to userspace.  That is, "if you want to
control it, better represent it", so that each component of the
domain, would be representted and its "knobs".

	Luben



