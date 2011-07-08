From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 8 Jul 2011 15:41:13 +0200
Message-ID: <20110708154113.3347eef0@stein>
References: <1309609482.2554.8.camel@mulgrave>
	<Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
	<20110703223757.0e2b5ee0@stein>
	<20110708153742.17121fa8@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110708153742.17121fa8@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Jul 08 Stefan Richter wrote:
> But today I did get the following crash on 3.0-rc6-71-g4dd1b49 x86-64 plus
> Alan's "USB: additional regression fix for device removal" when I powered
> down an USB hub with an empty USB card reader attached (or when I powered
> it up, impossible for me to say):

Judging from the missing hours in an application log, it happened at
power down of the hub = at removal of the card reader.
-- 
Stefan Richter
-=====-==-== -=== -=---
http://arcgraph.de/sr/
