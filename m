From: Christoph Hellwig <hch@infradead.org>
Subject: Re: iSCSI device naming issues
Date: Sun, 4 Jul 2004 21:11:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040704201111.GA8038@infradead.org>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:63187 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265792AbUGDULM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jul 2004 16:11:12 -0400
Content-Disposition: inline
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

On Thu, Jul 01, 2004 at 07:28:03PM +0530, Surekha.PC wrote:
> 
> Whenever an iSCSI device is configured in the system, a hotplug
> event is generated which invokes udev for device node creation.
> iSCSI driver has a CALLOUT rule for udev to generate a unique
> name for iSCSI devices.
> 
> The iSCSI callout program receives a sysfs device path like
> /sys/block/sdc whenever a block device is added. From the device
> symlink under /sys/block/sdc, it obtains the corresponding device
> path under /sys/devices/.. . It extracts the device quadruple
> (c,b,t,l) and identifies iSCSI device by parsing the path
> /sys/class/scsi_host/iscsi/c:b:t:l. For c:b:t:l as 0:0:0:0,
> iSCSI device name will be /udev/iscsib0t0l0.
> P.S: <hostX> is replaced by "iscsi" above to lookup for iSCSI devices.

Please just use the standard naming scheme instead of inventing
your own names.

