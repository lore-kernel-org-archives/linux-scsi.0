From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/2] convert libsas to the libata new eh
Date: Mon, 24 Jan 2011 15:16:51 -0600
Message-ID: <1295903811.15425.16.camel@mulgrave.site>
References: <1295797260.3007.118.camel@mulgrave.site>
	 <4D3DEB5B.9080803@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1AXVQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 16:16:57 -0500
In-Reply-To: <4D3DEB5B.9080803@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>

On Mon, 2011-01-24 at 16:12 -0500, Jeff Garzik wrote:
> About to dive into this.

You're welcome.

>   Thanks for tackling the new-EH conversion, 
> libsas is the last straggler in this regard.

No it's not ... there's still ipr (and any other external consumer).
In it's current form, the new eh simply wasn't usable externally.  As I
said for ipr in the intro blurb, I can't see a way to convert it without
making it attach fully to libsas, although an alternative might be to
get the raid transport class to proxy.

>   As you noted, "old-EH" is 
> now a synonym for "SAS EH code path".

Say more "external EH code path".

James


