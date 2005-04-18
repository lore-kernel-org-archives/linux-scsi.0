From: Peter Missel <peter.missel@onlinehome.de>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Mon, 18 Apr 2005 19:55:27 +0200
Message-ID: <200504181955.28178.peter.missel@onlinehome.de>
References: <200412311343.42484.peter.missel@onlinehome.de> <20050409140218.GC8669@parcelfarce.linux.theplanet.co.uk> <200504092344.41310.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:42228 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S261164AbVDRR4F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 13:56:05 -0400
In-Reply-To: <200504092344.41310.peter.missel@onlinehome.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Hello?

> Back to the original topic ... do you have any news with regard to putting
> the code back into the sym8xx driver that reads the user configured
> channel/device negotiation settings (transfer speed and width limits,
> timeouts, disconnect, etc. etc.) from the EEPROM? This is really causing
> headaches here with those setups that use external devices, slightly buggy
> devices, long cables and similar stuff where the auto-detected defaults
> aren't working.
>
> Many thanks!
>
> regards,
> Peter
>
