From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 18:28:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620162801.24988@smtp.wanadoo.fr>
References: <Pine.LNX.4.44.0206201210420.8225-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0206201210420.8225-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andries Brouwer <aebr@win.tue.nl>, Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

>Absolutely. I suspect that the _real_ issues start coming up only once
>people start using this for useful work, and we should just accept that
>the format (for now) is in flux. But that doesn't mean that we shouldn't
>try to make it reasonably sane from the very start.
>
>And make sure that the naming convention works for both IDE and SCSI (ie
>there should be a way to figure out _portably_ whether a device is a disk
>or CD-RW or whatever, without even knowing whether it's SCSI or IDE).

Looking at how other kind of device trees are doing (typically
Open Firmware), I beleive this can be acheived by having a "type"
node (ie. file).

Also, there are lots of good reasons to put device/driver settings as
"properties" of the device node in the device tree, which ends up having
proc-like files under each device node.
We could define some standard ones (like the device type) and provide a
simple way (proc-like) for drivers to add more properties, thus replacing
in most cases the need for ioctls.

Ben.


