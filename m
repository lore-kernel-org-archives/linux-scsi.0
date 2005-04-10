From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] attach aic7xxx to the spi transport class.
Date: Sun, 10 Apr 2005 14:17:50 -0500
Message-ID: <1113160671.6737.15.camel@mulgrave>
References: <1113159507.6737.10.camel@mulgrave>
	 <20050410190521.GH8669@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62166 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261576AbVDJTR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 15:17:59 -0400
In-Reply-To: <20050410190521.GH8669@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2005-04-10 at 20:05 +0100, Matthew Wilcox wrote:
> I thought QAS and IU were also U160 properties since the sym1010 supports
> them.  We just haven't found any drives yet that're willing to negotiate
> them ...

Theoretically, they are (and the 7xxx has support for them).  What I
find is that even when I have ultra320 drives willing to do QAS and IU,
they refuse to negotiate them except at u320 speeds ... I can put them
in, I just don't know how useful they actually are.

James


