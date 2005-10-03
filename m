From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 03 Oct 2005 12:28:12 -0400
Message-ID: <43415C1C.70202@pobox.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org>	 <433D8542.1010601@adaptec.com> <1128113158.12267.29.camel@mulgrave> <433DB6BE.4020706@adaptec.com> <433DDA8F.6050203@pobox.com> <43414DDE.4050804@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:41116 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751118AbVJCQ2U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 12:28:20 -0400
In-Reply-To: <43414DDE.4050804@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, Patrick Mansfield <patmans@us.ibm.com>, ltuikov@yahoo.com, Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> As opposed to those vendors saying: We _really_ need 64 bit LUNS
> and it would be really nice to get rid of HCIL, etc, etc.

Everybody agrees with this 100%

Note that James submitted a sdev_printk() patch in the past few days, 
which assists in removing HCIL from the SCSI core.


> IMO, 64 bit LUNs and no HCIL is more important than "transport
> attributes" and should've _preceded_ them.

Agreed.  But that's a lot of work, and I doubt people want to delay SAS 
further to wait for complete HCIL elimination.


> The fact that you're trying to umbrella them together, doesn't
> make it _technologically_ correct.

It's muddled together, yes.  That doesn't make it any less correct. 
It's just not a clean, immediate separation.  Its a separation that 
takes time.

	Jeff


