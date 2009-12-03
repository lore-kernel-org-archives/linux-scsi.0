From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Thu, 3 Dec 2009 22:17:58 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca> <4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756242AbZLCVRx@vger.kernel.org>
In-Reply-To: <4AF0CFE1.8050407@tomt.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: Jeff Garzik <jeff@garzik.org>, tfjellstrom@shaw.ca, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Nov 2009, Andre Tomt wrote:

> Identical issues with the AOC-SASLP-MV8 card with 8 Seagate Barracuda 
> 7200.11 1.5TB drives using the mvsas driver. Creating a md raid array 
> seems to trigger it nearly instantly, however other loads do not trigger 
> it as fast (if at all, only tested briefly with paralell dd).

Would just like to chime in with a "me too" on this. I've tried both 
ubuntu 9.10 kernel (2.6.31) and their 10.04 pre-alpha (guess it's 
2.6.32-rc8) and mvsas + AOC-SASLP-MV8 is pretty much unusable. If I start 
md creation it stalls immediately and gets nowhere, last time I tried it 
md claimed it had written 160 blocks then it stalled (all drive LEDs on 
the controller is constantly lit).

If I boot without drives and then hot-plug the drives, it immediately 
oops:es.

Any code/fixes I can try, this is a lab machine so I can easily do 
whatever needed with it...

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
