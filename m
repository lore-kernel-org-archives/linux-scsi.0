From: "Martin Schwenke" <martin@meltin.net>
Subject: Re: [PATCH] /proc/scsi/map
Date: Fri, 21 Jun 2002 08:59:19 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206202259.IAA01298@thucydides.inspired.net.au>
References: <20020620165553.GA16897@win.tue.nl>
	<Pine.LNX.4.44.0206201046340.8225-100000@home.transmeta.com>
Reply-To: "Martin Schwenke" <martin@meltin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0206201046340.8225-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

>>>>> "Linus" == Linus Torvalds <torvalds@transmeta.com> writes:

    Linus> But driverfs also gives information that /sbin/hotplug doesn't:

    Linus> [...]

    Linus> In other words, it's just a way of exposing information
    Linus> that the kernel already has, and that the kernel has to
    Linus> have _anyway_.

Does it have to be limited ot information that the kernel already has?

In particular, I'm thinking of the SCSI standard inquiry and EVPD
inquiry pages.  Mike Sullivan's patch does some SCSI inquiries and
extracts information from the results.  I'm wondering if the SCSI
driver could just do all of the available EVPD inquiries (available
pages are listed in the TOC on EVPD inquiry page 0), and use driverfs
to expose all of that (binary) information.

Right now the inquiries can be done from userspace using an ioctl().

peace & happiness,
martin
