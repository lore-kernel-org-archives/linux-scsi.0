From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 10:01:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206200959390.8225-100000@home.transmeta.com>
References: <20020620173654.O29373@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020620173654.O29373@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@suse.de>
Cc: Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>



On Thu, 20 Jun 2002, Dave Jones wrote:
>
> Is this the same bug that causes this wierdo..
>
> (davej@mesh:drivers)$ pwd
> /driver/bus/pci/drivers
> (davej@mesh:drivers)$ ls -l
> ls: VIA 82C686A/B: No such file or directory

No, that's a separate issue: a device that has an embedded "/" in the
filename is not something you can look up in a UNIX filesystem.

So drivers should avoid using "/" in their name.

(or driverfs might convert them automatically, although I personally think
we should just avoid them).

		Linus

