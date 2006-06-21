From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] Improve SCSI device type decoding
Date: Wed, 21 Jun 2006 12:48:42 -0600
Message-ID: <20060621184842.GA1630@parisc-linux.org>
References: <20060621165300.GX1630@parisc-linux.org> <449989BB.1010205@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53689 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932321AbWFUSsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 14:48:43 -0400
Content-Disposition: inline
In-Reply-To: <449989BB.1010205@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 21, 2006 at 02:02:35PM -0400, Douglas Gilbert wrote:
> Not forgetting peripheral device types 1eh and 1fh
> which are well known logical unit and unknown or
> no device type respectively.

I don't think you read the whole patch ;-)

+       if (type == 0x1e)
+               return "Well-known LUN   ";
+       if (type > ARRAY_SIZE(scsi_device_types))
+               return "Unknown          ";

Did you want to distinguish between a device of type unknown and a
device type Linux doesn't know about?
