From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Linux 2.6.18-rc6
Date: Sun, 17 Sep 2006 09:05:09 -0500
Message-ID: <1158501909.3485.1.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0609031939100.27779@g5.osdl.org>
	 <20060905122656.GA3650@aepfle.de>
	 <1157490066.3463.73.camel@mulgrave.il.steeleye.com>
	 <20060906110147.GA12101@aepfle.de>
	 <1157551480.3469.8.camel@mulgrave.il.steeleye.com>
	 <20060907091517.GA21728@aepfle.de>
	 <1157637874.3462.8.camel@mulgrave.il.steeleye.com>
	 <1158378424.2661.150.camel@fc6.xsintricity.com>
	 <20060917053815.GA10918@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48525 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750989AbWIQOFf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Sep 2006 10:05:35 -0400
In-Reply-To: <20060917053815.GA10918@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: Doug Ledford <dledford@redhat.com>, Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sun, 2006-09-17 at 07:38 +0200, Olaf Hering wrote:
> As pointed out in private mail, this patch fixes the machine check for
> me. Thanks Doug.
> 
> Maybe the AHC_ULTRA2 feature check is needed as well for other cards.

It is ... the non ULTRA2 non twin cards might not have this register
(and if they do, it doesn't reflect the LVD/SE bus setting).

This is a pretty significant alteration, so it's not a -rc candidate,
but I'll put it in scsi-misc and see how it works out.

James


