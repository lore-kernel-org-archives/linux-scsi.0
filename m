From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [2.6 patch] let AIC7{9,X}XX_BUILD_FIRMWARE depend on !PREVENT_FIRMWARE_BUILD
Date: Sun, 01 Aug 2004 13:16:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8F889225785C2F3936338C47@aslan.scsiguy.com>
References: <20040801185543.GB2746@fs.tum.de> <20040801191118.GA7402@mars.ravnborg.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aslan.scsiguy.com ([63.229.232.106]:40977 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S266133AbUHATSD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Aug 2004 15:18:03 -0400
In-Reply-To: <20040801191118.GA7402@mars.ravnborg.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@fs.tum.de>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, luben_tuikov@adaptec.com

>> The patch below lets AIC7{9,X}XX_BUILD_FIRMWARE depend on 
>> !PREVENT_FIRMWARE_BUILD.
> 
> Justin, I agree with this change. Please let me know if I shall forward
> the patch to Linus, or you will take care.
> 
> 	Sam

Luben Tuikov is the current maintainer of these drivers.

--
Justin

