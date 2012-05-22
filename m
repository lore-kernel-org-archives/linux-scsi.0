From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
Date: Tue, 22 May 2012 10:25:55 +0100
Message-ID: <20120522102555.3830d0bd@pyramind.ukuu.org.uk>
References: <1336491453.1933.67.camel@x61.thuisdomein>
	<Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
	<20120515153539.GA25206@kroah.com>
	<1337099344.13455.9.camel@x61.thuisdomein>
	<20120515173613.3c8c2f1f@pyramind.ukuu.org.uk>
	<1337676514.7898.8.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337676514.7898.8.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 22 May 2012 10:48:34 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> On Tue, 2012-05-15 at 17:36 +0100, Alan Cox wrote:
> > Possibly we should have a hostadapter flag indicating if the cache noise
> > is expected nuisance or not. That way if hardcore SCSI on real cables
> > wants to keeep it then it can still be shut up for USB where its the
> > norm and just irrelevant noise.
> 
> 0) Nobody suggested anything else so maybe I should try to come up with
> a patch that does that. A slight problem is that I'm not at all familiar
> with the SCSI code. And I don't think I own any actual SCSI hardware.

Give it a go.. only one way to learn 8)

> 1) Anyhow: hostadapter flags? Are those perhaps the bitfields starting
> with "active_mode" in "struct Scsi_Host"?

It can probably go in the scsi_host_template. It's going to be per
adapter and fixed. It will still be accessible then via
host->hostt->whatever. That also makes it easier to set correctly.

Alan
