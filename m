From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 13:09:07 -0400
Message-ID: <446A0733.7030507@garzik.org>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F906.7040602@gmail.com>	 <1147796999.3505.42.camel@mulgrave.il.steeleye.com>	 <446A0053.5070203@gmail.com> <1147798226.3505.56.camel@mulgrave.il.steeleye.com> <446A06C7.5050609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:31878 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932150AbWEPRJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 13:09:10 -0400
In-Reply-To: <446A06C7.5050609@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Tejun Heo wrote:
> Okay, will do in scsi_priv.h
> 
> Jeff, it seems that we need to reset #upstream and rebuild it.  Do you
> have any other idea than resetting libata-tj#for-jeff and
> libata-dev#upstream?

Just apply an update patch that achieves the desired result.

	Jeff



