From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: 29 Mar 2003 08:43:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048948992.21525.1.camel@mulgrave>
References: <20030325100704.GC3868@beaverton.ibm.com>
	<1048613872.2070.12.camel@mulgrave>
	<20030325184530.GA1202@beaverton.ibm.com>
	<1048618939.1790.29.camel@mulgrave>
	<20030325232920.GB2692@beaverton.ibm.com>
	<1048779761.1789.21.camel@mulgrave>
	<20030328173253.A32352@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030328173253.A32352@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-03-28 at 19:32, Matthew Dharm wrote:
> Well, Linus wants this to work for usb-storage more short-term than
> long-term....

Well, I think Mike's given us everything you need.  We can use the
set_device_offline to alter the remove-single-device path to offline the
device, wait for the returning I/Os to complete or error and then remove
the device.

You can then trigger this from your hotplug scripts.

James


