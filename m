From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Notify about errors during initialization
Date: Tue, 6 Jan 2004 17:18:43 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106171843.A18507@infradead.org>
References: <20040105021047.GD30408@one-eyed-alien.net> <Pine.LNX.4.44L0.0401051659180.604-100000@ida.rowland.org> <20040105221302.A7678@infradead.org> <20040105233221.GC1936@beaverton.ibm.com> <20040106161731.A17858@infradead.org> <20040106091538.A10957@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:52494 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264501AbUAFRTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 12:19:11 -0500
Content-Disposition: inline
In-Reply-To: <20040106091538.A10957@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Jan 06, 2004 at 09:15:39AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Jan 06, 2004 at 09:15:39AM -0800, Patrick Mansfield wrote:
> Why not trigger off the scsi_host hotplug event? Though we will have races
> similiar to udev where the sysfs attribute files are created after the
> hotplug event - we really ought to have a device_init/setup, create the
> sysfs files, then device_add/enable.

Because some drivers (like the ieee1394) don't want scanning to happen.
They can easily chose that by not sending a scan event.

