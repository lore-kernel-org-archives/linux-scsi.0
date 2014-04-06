From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: esp_scsi QTAG in FAS216
Date: Mon, 7 Apr 2014 08:33:12 +1200
Message-ID: <CAOmrzkL_6Y2RhpKANmTEWL53-6Ts+PF9Hhk_4Fh1s0wx7f_NhQ@mail.gmail.com>
References: <CAOmrzkKP4YcvnHcrtucMvS9WSaeg+6-qnobOWN6hBK=wkUHemg@mail.gmail.com>
	<CAMuHMdUH=9sv-Vb3ZTAGyfvEQOO0x0x1cUYhfd7040k8d+bSYg@mail.gmail.com>
	<5231DF69.6070807@aalto.fi>
	<20140404.162830.1700547572091852195.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49560 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaDFUdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Apr 2014 16:33:13 -0400
In-Reply-To: <20140404.162830.1700547572091852195.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Tuomas Vainikka <tuomas.vainikka@aalto.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, linux-scsi@vger.kernel.org, jongk@linux-m68k.org

Hello Dave, Tuomas,

>> Also, looking at the timeout formulae in the old NCR53C9x.c driver,
>> the values would be different for FAS216. Why was this dropped from
>> the modern esp_scsi?
>
> I've never seen a formula for any ESP or FAS chip for the timeout
> other than the one mentioned in huge comment in
> esp_set_clock_params(), although I do see the 7668 instead of 8192
> factor being used in the old NCR53C9x driver.

I haven't gone far enough back in the 53C9x revision history to be
certain. but it would seem to me that Kars de Jong added that FAS
special case.

Can you confirm that, Kars? Any recollection as to the reason?

Cheers,

  Michael
