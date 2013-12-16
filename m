From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Sun, 15 Dec 2013 21:49:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312152146040.3175-100000@netrider.rowland.org>
References: <1387145674.2284.60.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:57737 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752231Ab3LPCtQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2013 21:49:16 -0500
In-Reply-To: <1387145674.2284.60.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Sun, 15 Dec 2013, James Bottomley wrote:

> No, I was thinking of the two thread scan bug (i.e. two scan threads)
> not one scan and one remove, which is a bug in the old code.

By the way, the existing code doesn't allow two threads to scan a
target at the same time.  They would both have to hold the host's
scan_mutex.

On the other hand, as far as I can see there's nothing to prevent two
threads from removing a device at the same time.  But that wouldn't 
cause any problems.

Alan Stern

