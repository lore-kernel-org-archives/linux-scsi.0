From: David Miller <davem@davemloft.net>
Subject: Re: esp_scsi QTAG in FAS216
Date: Fri, 04 Apr 2014 16:28:30 -0400 (EDT)
Message-ID: <20140404.162830.1700547572091852195.davem@davemloft.net>
References: <CAOmrzkKP4YcvnHcrtucMvS9WSaeg+6-qnobOWN6hBK=wkUHemg@mail.gmail.com>
	<CAMuHMdUH=9sv-Vb3ZTAGyfvEQOO0x0x1cUYhfd7040k8d+bSYg@mail.gmail.com>
	<5231DF69.6070807@aalto.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <5231DF69.6070807@aalto.fi>
Sender: linux-m68k-owner@vger.kernel.org
To: tuomas.vainikka@aalto.fi
Cc: geert@linux-m68k.org, schmitzmic@gmail.com, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Tuomas Vainikka <tuomas.vainikka@aalto.fi>
Date: Thu, 12 Sep 2013 18:36:09 +0300

> Does anyone have the register descriptions for the FAS216 chip? It
> would seem that receiving only one byte during reconnect is perfectly
> normal [1] unless SCSI-2 features are explicitly enabled (which
> esp_scsi doesn't seem to be doing).

This is quite possibly true.  I've never see it happen myself while
testing the driver though.

> Also, looking at the timeout formulae in the old NCR53C9x.c driver,
> the values would be different for FAS216. Why was this dropped from
> the modern esp_scsi?

I've never seen a formula for any ESP or FAS chip for the timeout
other than the one mentioned in huge comment in
esp_set_clock_params(), although I do see the 7668 instead of 8192
factor being used in the old NCR53C9x driver.

I wrote esp_scsi.c based upon the old sparc ESP driver and the docs
I had available to me.
