From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Serial Attached SCSI Driver Interface (SDI)
Date: Mon, 15 Nov 2004 13:29:13 -0500
Message-ID: <4198F579.9080606@adaptec.com>
References: <60807403EABEB443939A5A7AA8A7458B5C0F3D@otce2k01.adaptec.com> <4198EF00.2010305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:22408 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261648AbUKOS33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 13:29:29 -0500
In-Reply-To: <4198EF00.2010305@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric.Moore@lsil.com

Jeff Garzik wrote:
> ug.
> 
> These ioctl mechanisms almost always (a) have design flaws [which cannot 
> be corrected, since they are in a spec] and (b) duplicate other 
> functionality of the Linux kernel.  The SNIA ioctl mess is a great 
> example of this.
> 
> Without any additional info, my first reaction is that this is yet more 
> stuff Linux doesn't need.

I don't want to speculate on whether it will or not be an ioctl
mechanism.  But most importantly, by architecture design, SAS
really _needs_ a control management infrastructure of its components
and _maybe_ a representation somewhere in the OS.  Since it really
represents a "storage network" and in certain instances a complicated
one at that.

That control management infrastructure would be shared by (used by
both) the OS and the kernel (for the appropriate functionaly needed/provided).

I've just got official word that SDI would be "the industry
standard version of CSMI".

It's a good thing,
	Luben

