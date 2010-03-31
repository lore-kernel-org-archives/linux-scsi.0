From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 17:37:20 +0200
Message-ID: <v2s59ca64281003310837mc19ec688z505d9af52ea1f8d0@mail.gmail.com>
References: <Pine.LNX.4.44L0.1003261705340.23253-100000@netrider.rowland.org>
	<4BAD275A.7050903@interlog.com> <59ca64281003300044g53ae5170xaf198bf99964fc36@mail.gmail.com>
	<h2n59ca64281003310439z2f317661xf1d501a5f21c64b3@mail.gmail.com>
	<1270049200.2302.320.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <1270049200.2302.320.camel@laptop>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jerone Young <jerone.young@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 31, 2010 at 5:26 PM, Jerone Young
<jerone.young@canonical.com> wrote:
> Hmm .. seems like your using a custom kernel.
>
> Can you try Ubuntu 10.04 daily build live disk and see if you see the
> same issue:
> http://cdimage.ubuntu.com/daily-live/20100331/

I discovered this about two weeks ago an up-to-date Ubuntu 9.10
distro, then upgraded to 10.04 where it still existed. In order to get
USB debug information I compiled my own kernel (once based off of the
Ubuntu 10.04 sources and once based off of the 2.6.32.9 stable sources
from kernel.org). I very much doubt that this issue does not exist on
the latest 10.04 daily build.

-Jonas
