From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: 06 May 2003 11:28:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052238508.1819.42.camel@mulgrave>
References: <20030505083315.GB8416@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:51717 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263958AbTEFQQE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 12:16:04 -0400
In-Reply-To: <20030505083315.GB8416@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

On Mon, 2003-05-05 at 03:33, Mike Anderson wrote:
> Example tree:
> 
> # tree /sys/class/scsi_host
> /sys/class/scsi_host
> |-- host0
> |   |-- cmd_per_lun
> |   |-- device -> ../../../devices/pci0/00:09.0/host0
> |   |-- host_busy
> |   |-- sg_tablesize
> |   |-- unchecked_isa_dma
> |   `-- unique_id

Could you elaborate a bit more on why the host properties are under the
class tree, but the scsi_device properties are under the device tree.

I think this could be my misunderstanding of the class concept:  I
thought it was going to be a unifying abstraction, e.g. a class for all
tape devices (be they SCSI, ide or the oddball qic ones) that would
export a unifying interface that all tapes could use.  Therefore, you
have a device with a set of intrinsic properties exposed in the device
tree plus a set of classes whose interfaces it chooses to export.

I could see us adding a scsi_device class and moving all the device
properties under there too, I suppose.

What I think I'm looking for is clarification of what is a "class
property" vs what is a "device property"

James


