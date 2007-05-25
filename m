From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 0/7] Asynchronous Notification for ATAPI devices (resend)
Date: Thu, 24 May 2007 23:14:13 -0400
Message-ID: <46565485.3000602@garzik.org>
References: <20070509163756.dd8136c7.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50742 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbXEYDOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 May 2007 23:14:16 -0400
In-Reply-To: <20070509163756.dd8136c7.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, Andrew Morton <akpm@linux-foundation.org>

Kristen Carlson Accardi wrote:
> Hi Jeff,
> Here are the AN patches again, they have not changed with the exception
> of patch #1, which does set the host flag in board_ahci and board_ahci_pi
> now (thanks Tejun).
> 
> This patch series implements Asynchronous Notification (AN) for SATA
> ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
> which support this feature will send a notification when new media is
> inserted and removed, preventing the need for user space to poll for
> new media.  This support is exposed to user space via a flag that will
> be set in /sys/block/sr*/capability_flags.  If the flag is set, user
> space can disable polling for the new media, and the genhd driver will
> send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.
> 
> Note that this patch only implements support for directly attached
> drives - AN with drives attached to a port multiplier requires 
> additional changes.

Patches look OK to me...  it will take some coordination for the 
non-libata bits.  I think Andrew mentioned some of this.  And if the 
SCSI bits get stuck in the SCSI maintainer's bit bucket, let me know.

	Jeff



