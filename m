From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Serial Attached SCSI Driver Interface (SDI)
Date: Mon, 15 Nov 2004 13:01:36 -0500
Message-ID: <4198EF00.2010305@pobox.com>
References: <60807403EABEB443939A5A7AA8A7458B5C0F3D@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:60354 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261651AbUKOSBz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 13:01:55 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B5C0F3D@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: "Tuikov, Luben" <Luben_Tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric.Moore@lsil.com

Salyzyn, Mark wrote:
> CSMI is an ioctl mechanism. Have incorporated this interface into my
> working version of the driver. Duplication is already showing, witness
> Eric Moore's (rejected) submission.
> 
> The T10 document Luben refers to, is to start the groundwork and does
> not list any specific interface yet. March 2006 is the `public release
> data' ... Get your comments in now!


ug.

These ioctl mechanisms almost always (a) have design flaws [which cannot 
be corrected, since they are in a spec] and (b) duplicate other 
functionality of the Linux kernel.  The SNIA ioctl mess is a great 
example of this.

Without any additional info, my first reaction is that this is yet more 
stuff Linux doesn't need.

	Jeff


