From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Mon, 18 Nov 2002 00:20:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117232004.GA1779@win.tue.nl>
References: <20021117195258.GC3280@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021117195258.GC3280@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>

On Sun, Nov 17, 2002 at 02:52:58PM -0500, Doug Ledford wrote:

> Working on a fix.  Haven't decided how to do it yet.

I encountered similar phenomena with usb-storage.
I think the proper solution is to never automatically
scan for a partition table.
We perhaps need to do that at boot time, but in all other
cases user space can ask the kernel to read a partition table.
For usb-storage things work fairly well (for some kernels)
using
	blockdev --rereadpt /dev/sdx

Andries


