From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer
 kernels
Date: Thu, 16 Apr 2015 10:28:16 -0700
Message-ID: <1429205296.2196.22.camel@HansenPartnership.com>
References: <CAH_2Ghf565hKovkkccP_z6SO8v=7Ji=wdvL8YPnZNZ9WUUfGWg@mail.gmail.com>
	 <1429046165.2209.54.camel@HansenPartnership.com>
	 <CAH_2GhcsaDoxuxBwTT7cUsfp+5e_KjxtkJ4tFE1N05U=FCkJnA@mail.gmail.com>
	 <1429161361.2608.4.camel@HansenPartnership.com>
	 <CAH_2GhdsUqjmG4V-9X5QRkwNiVg9O5qp9Hpskis39qy=dmgYyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56877 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbbDPR2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2015 13:28:18 -0400
In-Reply-To: <CAH_2GhdsUqjmG4V-9X5QRkwNiVg9O5qp9Hpskis39qy=dmgYyA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2015-04-16 at 10:26 -0700, Adam Talbot wrote:
> Wow, I forgot how long it takes to compile a full kernel.  Glad I ran
> Gentoo for a few years and knew how to compile and apply patches. I
> will admit I had to dust off some mental cobwebs.
> 
> Pre-patched 4.0.0 kernel tree: Oops, as expected
> Patched 4.0.0 kernel tree: IT WORKED!!!!!  Basic mount, and checking a
> few files all looks good.  I will start a RAID check as that should
> really push the driver. I will report back tomorrow when it finishes.

Could you also check the direct ATA attachment case to make sure I
didn't screw that up.  The fix is based on a theory about how the driver
operates rather than any actual documentation.

Thanks,

James


