From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mvsas errors in 2.6.36
Date: Sun, 5 Dec 2010 11:58:20 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1012051156400.9121@uplift.swm.pp.se>
References: <201010290650.32892.thomas@fjellstrom.ca> <4CE3912E.6060904@tomt.net> <201012012329.54944.thomas@fjellstrom.ca> <201012020249.00367.thomas@fjellstrom.ca> <4CF79C60.9030107@shiftmail.org>
 <AANLkTinVK8FAApP2zP8gqmPhgPo4ZeUMRRJ4cD+O1iza@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:33498 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab0LELIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Dec 2010 06:08:46 -0500
In-Reply-To: <AANLkTinVK8FAApP2zP8gqmPhgPo4ZeUMRRJ4cD+O1iza@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Audio Haven <audiohaven@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, 5 Dec 2010, Audio Haven wrote:

> Thanks to everyone who helped making mvsas stable as it finally works!

Did you include smartctl reading under load as well, does that now work 
reliably?

I've had my AOC-SASLP-MV8 lying in a box for about a year because I just 
gave up trying to get it to work, would be very welcome news to see it 
working in 2.6.37.

The changes made, are they backportable to 2.6.32 by any chance?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
