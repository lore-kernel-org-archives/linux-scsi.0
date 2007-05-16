From: "Leigh Blackwell" <leigh@codacommerce.com>
Subject: RE: Dell CERC ATA100/4ch support
Date: Wed, 16 May 2007 16:38:04 +0100
Message-ID: <028001c797d0$34656340$15b2a8c0@newbrains>
References: <1179327908.3787.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pih-relay04.plus.net ([212.159.14.131]:59694 "EHLO
	pih-relay04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbXEPPk3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2007 11:40:29 -0400
In-Reply-To: <1179327908.3787.29.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 374792@bugs.debian.org, akpm@osdl.org, linux-scsi@vger.kernel.org, Seokmann.Ju@lsil.com, 'Matt Domsch' <Matt_Domsch@dell.com>

Hi James,

I'm running FW 6.62 and the latest megaraid doesn't detect the controller.

The suggestion made on the bug list was to roll back the firmware 6.61 which
I am unsure on doing, as Dell are not going to advocate flashing a bios with
a firmware not formerly built for that machine (1600SC). 

So the new megaraid driver(s) built into the 2.6 kernel are at fault and
they are produced by LSI and there current position is they should still be
supporting this device?

Thanks

Leigh

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: 16 May 2007 16:05
To: Leigh Blackwell
Cc: 374792@bugs.debian.org; akpm@osdl.org; linux-scsi@vger.kernel.org;
Seokmann.Ju@lsil.com; Matt Domsch
Subject: Re: Dell CERC ATA100/4ch support

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


