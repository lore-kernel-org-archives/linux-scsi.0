From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 15:10:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014220959.GA1478@beaverton.ibm.com>
References: <20021014054035.GA10686@codepoet.org> <20021014000602.F30278@one-eyed-alien.net> <20021014071252.GB13512@codepoet.org> <20021014154719.GE21010@nbkurt.casa-etp.nl> <20021014161922.GB2940@beaverton.ibm.com> <20021014204122.GB24904@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021014204122.GB24904@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

Erik Andersen [andersen@codepoet.org] wrote:
> It was my understanding that the comments (which were present
> long before I changed anything) refer mainly to the fact that
> hotswapping with a normal SCSI subsystem (without additional
> electronic support for hotswapping) is electrically unsafe and is
> likely to fry up your drives and your SCSI host controller.  For
> people with hotswap safe hardware (or using ieee1394 or usb mass
> storage devices), hotswapping is perfectly normal and safe, and
> the scarry comments do not apply.

I agree on the comment being more about hardware.

but..

While it may run many times the transversal of a list and references off
a element in that list concurrent with a process that might be removing
a entry from the list will eventually cause a problem. This is probably
hard to hit, but many drivers and the SCSI proc interface iterate over
the host_queue list so it is possible.

-andmike
--
Michael Anderson
andmike@us.ibm.com

