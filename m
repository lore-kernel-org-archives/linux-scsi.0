From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Dell CERC ATA100/4ch support
Date: Wed, 16 May 2007 11:05:08 -0400
Message-ID: <1179327908.3787.29.camel@mulgrave.il.steeleye.com>
References: <01e801c797bf$34f7ef00$15b2a8c0@newbrains>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55160 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754331AbXEPPGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2007 11:06:00 -0400
In-Reply-To: <01e801c797bf$34f7ef00$15b2a8c0@newbrains>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Leigh Blackwell <leigh@codacommerce.com>
Cc: 374792@bugs.debian.org, akpm@osdl.org, linux-scsi@vger.kernel.org, Seokmann.Ju@lsil.com, Matt Domsch <Matt_Domsch@dell.com>

On Wed, 2007-05-16 at 14:36 +0100, Leigh Blackwell wrote:
> I have been looking at the issue with theses cerc devices, has this 
> bug 374792 been closed based on people reverting the firmware to < 6.61. 
> 
> Unfortunately Dell doesn't support a Firmware version that old on our 
> Server, is it possible to re-open this bug? I have been unable to get the
> current etch install to recognize my driver controller with any of the
> megaraid drivers.

Umm, but this is a bug in Dell Support isn't it?  I don't think there's
a kernel fix for that.

LSIs position is that in current kernels they only support this device
with the new megaraid driver and only for firmware version >= 6.61.
Surely you just need to get Dell and LSI on the same page?

James


