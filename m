From: Christoph Hellwig <hch@infradead.org>
Subject: Re: map gendisk (or blockdev) -> scsi_device
Date: Thu, 14 Jul 2005 20:56:13 +0100
Message-ID: <20050714195613.GA22935@infradead.org>
References: <db1npr$c1d$1@sea.gmane.org> <20050713143843.GC26025@infradead.org> <db3nei$nrs$1@sea.gmane.org> <20050713234654.GA7222@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:184 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263117AbVGNT4X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 15:56:23 -0400
Content-Disposition: inline
In-Reply-To: <20050713234654.GA7222@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Edward Falk <efalk@google.com>, linux-scsi@vger.kernel.org

On Wed, Jul 13, 2005 at 04:46:54PM -0700, Patrick Mansfield wrote:
> Add or use the attributes under the scsi_device, then use the
> /sysfs/block/sd/device symlink to find the corresponding scsi_device.

yupp, the /sys/block/* attributes are really only meant to be for
thing related to the actual block device, not the underlying hardware.

