From: Andi Kleen <ak@muc.de>
Subject: Re: Q: aacraid stability on 64-bit Linux?
Date: Thu, 15 Apr 2004 12:40:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3ad1dy154.fsf@averell.firstfloor.org>
References: <407E18B1.30508@neopathnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:41739 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S262293AbUDOKk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 06:40:59 -0400
In-Reply-To: <407E18B1.30508@neopathnetworks.com> (Dimitris Michailidis's
 message of "Wed, 14 Apr 2004 22:08:01 -0700")
List-Id: linux-scsi@vger.kernel.org
To: Dimitris Michailidis <dm@neopathnetworks.com>
Cc: linux-scsi@vger.kernel.org

Dimitris Michailidis <dm@neopathnetworks.com> writes:

> While looking for x86_64 servers with raid controllers a vendor
> indicated that the drivers for Adaptec raid controllers do not work
> reliably on 64-bit Linux.  The controller in question is a 2120S and I
> am interested in recent 2.4 and 2.6 x86_64 kernels in 64-bit mode.  I
> find the vendor's statement suspicious so I'd like to hear from those
> with experience with this configuration if there's any truth in it.

The I2O based Adaptec drivers are not 64bit clean at all and there
seems to be nobody interested in fixing this (it's a huge task) 
The aacraid driver seems to mostly work if you use the latest 
version.

-Andi

