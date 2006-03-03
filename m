From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 10:26:15 -0800 (PST)
Message-ID: <20060303182615.40405.qmail@web31812.mail.mud.yahoo.com>
References: <44086AD6.3060503@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:52632 "HELO
	web31812.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1161014AbWCCS0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 13:26:15 -0500
In-Reply-To: <44086AD6.3060503@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> More precisely, the _BIOS_ or an equivalent has to wait for the _boot_
> device (to load the kernel from). The _kernel_ has to wait for the
> device carrying the _initial root filesystem_.
> 
> If the final working root filesystem resides on a device or network
> resource which is more or less slow to be discovered, a minimal initial
> root filesystem is put onto a RAM disk which is loaded together with the
> kernel (a.k.a. an initrd).

Yes, this is exactly right.

    Luben

