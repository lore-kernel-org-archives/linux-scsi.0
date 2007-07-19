From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Date: Thu, 19 Jul 2007 19:56:53 +0200
Message-ID: <469FA5E5.3070301@gmail.com>
References: <20070716161539.075822000@pademelon.sonytel.be>	<20070716162206.529280000@pademelon.sonytel.be>	<20070718164351.a92ec032.akpm@linux-foundation.org>	<Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>	<20070719021752.35cb7daa.akpm@linux-foundation.org>	<Pine.LNX.4.62.0707191137470.8661@pademelon.sonytel.be> <20070719024730.03609f1f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S940985AbXGSR6y@vger.kernel.org>
In-Reply-To: <20070719024730.03609f1f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>
List-Id: linux-scsi@vger.kernel.org

On 07/19/2007 11:47 AM, Andrew Morton wrote:

> On Thu, 19 Jul 2007 11:39:32 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
>>> Oh dear.
>>>
>>> 	ps3rom_priv(dev) = host;
>>>
>>> that's 'orrid.  We have an identifier pretending to be a function, only we
>>> go and treat it as an lvalue.
>>>
>>> I mean, C code should look like C code, and the above just doesn't.
>>>
>>> Sigh.

You could insist that it be PS3ROM_PRIV() because then it at least also 
_looks_ like cpp...

Rene.
