From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LUN resizing
Date: Wed, 26 Nov 2003 09:48:04 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031126094804.A2717@infradead.org>
References: <1069708054.26088.127.camel@lt-sv> <1069774983.2061.28.camel@mulgrave> <1069776713.1787.36.camel@mulgrave> <1069839911.26091.443.camel@lt-sv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:5124 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264113AbTKZJsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 04:48:08 -0500
Content-Disposition: inline
In-Reply-To: <1069839911.26091.443.camel@lt-sv>; from Stefan.Voelkel@millenux.com on Wed, Nov 26, 2003 at 10:45:11AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Nov 26, 2003 at 10:45:11AM +0100, Stefan Voelkel wrote:
>       * a way to force the scsi stack to send out a read_capacity and
>         act on it (perhaps another /sys/ entry?), perhaps a hotplug
>         event that creates a new partition table, eg add the new space
>         as "unused" at the end of the device, write that table and
>         ioctl() to reread it.
>       * a way to fiddle around with live partitions,  a userspace tool
>         with a way to tell the kernel supsend/reactivate io on that
>         block device. it would have to take care of the filesystems
>         residing on the device.

No way.  You're better of using a proper volume manager instead of doing
this paritioning mess.

