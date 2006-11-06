From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Automatic LUN detectioning not working
Date: Mon, 06 Nov 2006 22:00:07 +0900
Message-ID: <1162818008.4551.1.camel@mulgrave.il.steeleye.com>
References: <20061106090702.GA8071@npjaco.netgroup.co.za>
	 <1162807123.3160.182.camel@laptopd505.fenrus.org>
	 <20061106100806.GA9343@npjaco.netgroup.co.za>
	 <1162809658.3160.205.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:21645 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1753029AbWKFNAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 08:00:44 -0500
In-Reply-To: <1162809658.3160.205.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: Jaco van der Schyff <jvds@netgroup.co.za>, linux-scsi@vger.kernel.org

On Mon, 2006-11-06 at 11:40 +0100, Arjan van de Ven wrote:
> ok this is curious; the device claims to be rev 3 scsi, so the kernel
> will have used the "REPORT_LUNS" command, which asks the device to tell
> the kernel which LUNs it has.. it seems it just plain lies if it doesnt'
> work for you.

I was about to remark on that too ... we need the dmesg of the boot
sequence to tell us if there's a REPORT_LUNS problem (in which case the
blacklist might need to be BLIST_NOREPORTLUN)

James


