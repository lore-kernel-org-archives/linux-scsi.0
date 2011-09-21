From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: HighPoint RocketRaid 620 vs. RocketRaid 640 -- supported?
Date: Wed, 21 Sep 2011 07:28:26 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1109210726250.31360@p34.internal.lan>
References: <alpine.DEB.2.02.1109191754531.7938@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1109191754531.7938@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Incase anyone is wondering the same thing, I contacted Highpoint and they 
said (confirmed) the 620 support (which I am using now) is built-in to the 
kernel and the 640 is not, so unless you like compiling kernel modules/out 
of tree drivers for a _boot_ volume and want a regular SATA 6.0gbps 
controller that supports TRIM, I'd go for the 620 even though it maxes out 
around 390-420MiB/s read where a real SAS controller supports 490-500MiB/s 
for an Intel 510 SSD, but remember, SAS controllers (at least the one I 
tested with does not support TRIM and there is no Intel SSD optimizer for 
Linux.

Justin.

On Mon, 19 Sep 2011, Justin Piszcz wrote:

> Hi,
>
> I have a HighPoint RocketRaid 620 and it works fine with 3.0+.
> The HighPoint RocketRaid 640 also has a Marvell 88SE9128, can anyne confirm 
> whether this (x4) PCI-e 2.0 card works in Linux with the built-in kernel 
> driver?
>
> Justin.
>
