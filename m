From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Fri, 04 Jul 2014 15:44:04 -0400
Message-ID: <53B70404.9080303@interlog.com>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-2-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48225 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbaGDToO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 15:44:14 -0400
In-Reply-To: <1404474875-109997-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 14-07-04 07:54 AM, Hannes Reinecke wrote:
> SCSI-2 defines only up to 256 LUNs with a flat namespace.

My SCSI-2 draft (revision 10b from August 1989) only has
3 bit LUNs placed in byte 1 of the command block, in the top
3 bits. There are also things called LUNTARs and LUNTRNs
at the message level.

8 bit LUNs do ring a distant bell, perhaps after SCSI-2?

Doug Gilbert

