From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: AIC94xx SAS question.
Date: Mon, 28 Apr 2008 11:35:49 +0200
Message-ID: <48159A75.6020400@ipax.at>
References: <20080421231940.GB5656@animx.eu.org>	<4812B66A.5000105@hopnet.net> <20080426145649.GA8848@animx.eu.org> <48140F9F.1070109@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:46677 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYD1Jfw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 05:35:52 -0400
In-Reply-To: <48140F9F.1070109@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: lnxgnome@hopnet.net, wakko@animx.eu.org

just for the records

Keith Hopkins wrote:
> SuSE loads the driver as a module and the firmware in initrd.  I haven't
> tried initramfs, nor compiling it into the kernel.
> 
> I unpacked my current initrd, and in it I found:
> 
> lib/firmware/aic94xx-seq.fw
> + some ql firmware that I don't need.
> 
> I'm not sure if the driver compiled for SuSE "just knows" to look in
> /lib/firmware, or how it finds the file.  It might have something to do
> with the firmware_class module in SuSE.
> I do remember that I needed to load 'edd' before 94xx, or it would not
> init the firmware.

this is a default behaviour of this and many other drivers.

> As for compiling the driver in the kernel, and putting the firmware in
> initrd/initramfs, you would have to force the init of the 94xx module to
> be after the initrd/initramfs was initialized, loaded and mounted.  I
> have not checked to see if that is currently possible.

in the end, there is no big deal in putting the firmware into the
initramfs. some distributions may work out of the box, some might
require a little tuning of an initramfs hook.

which leads me to my question: why are you absolutly against an
initramfs image? properly configured - and that is not a big deal
in current versions of mkinitramfs and current distributions - there
are few possibilities to break the setup.

if you require assistance, i can help.

cheers,
raoul
-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
