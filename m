From: "Martin Schwenke" <martin@meltin.net>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 17:09:44 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <aervbf$stj$2@main.gmane.org>
References: <20020620004442.GA19824@gum01m.etpnet.phys.tue.nl>
	<Pine.LNX.4.33.0206192149410.2638-100000@penguin.transmeta.com>
Reply-To: "Martin Schwenke" <martin@meltin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0206192149410.2638-100000@penguin.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

>>>>> "Linus" == Linus Torvalds <torvalds@transmeta.com> writes:

    Linus> Can't you add the SCSI devices to the device tree, and be
    Linus> done with it? 

Do you mean the /devices tree or the Open Firmware (OF) device-tree
(as in IEEE Std 1275).  I suspect that you mean the former, but...

    Linus> [...]

    Linus> All fixed at least to _some_ degree by giving the most
    Linus> complete address we can, ie something like

    Linus> 	/devices/root/pci0/00:02.0/02:1f.0/03:07.0

That looks similar, but not identical to an Open Firmware node for a
SCSI device:

  device-tree/pci@3fff5e09000/pci@b,6/scsi@1,1/sd/...

Why not use the structure of, and a subset of the capabilities of, an
OF device-tree for building /devices?  It's a little more verbose, but
it's a standard and it fits the current problem pretty well.

I've been working on some hardware inventory stuff at IBM that uses an
augmented OF device-tree (as a directory tree in userspace) to keep
track of useful stuff...

peace & happiness,
martin
