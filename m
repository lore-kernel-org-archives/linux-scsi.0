From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Adding/Removing SCSI Devices in LLD's in 2.6 Kernel
Date: Mon, 31 Jan 2005 21:03:13 +0000
Message-ID: <20050131210313.GA19719@infradead.org>
References: <91888D455306F94EBD4D168954A9457C010BAC51@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33968 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261369AbVAaVDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 16:03:16 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C010BAC51@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

> (1) Is it okay for scsi lower layer drivers
> report device changes to the scsi mid-layer when 
> the events are received, using scsi_add_device and
> scsi_remove_device?

Yes.  But be aware that they can't be called from irq
context.

> (3) How does the app know about the asyn events?

The kernel sends hotplug events.  I don't know
the details on how to hook into the hotplug subsystem,
please ask the hotplug-devel list for details.

