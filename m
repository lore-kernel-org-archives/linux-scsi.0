From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/1] scsi: expose AN support to user space
Date: Fri, 12 Oct 2007 17:09:46 -0400
Message-ID: <470FE29A.7050605@garzik.org>
References: <200710032104.l93L40CM008614@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56533 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbXJLVJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2007 17:09:55 -0400
In-Reply-To: <200710032104.l93L40CM008614@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: akpm@linux-foundation.org, kristen.c.accardi@intel.com, htejun@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>

akpm@linux-foundation.org wrote:
> From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> If a scsi_device supports async notification for media change, then let user
> space know this capability exists by creating a new sysfs entry
> "media_change_notify", which will be 1 if it is supported, and 0 if not
> supported.  Create a routine which allows scsi devices to send a uevent when
> media change events occur.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> Acked-by: Jeff Garzik <jeff@garzik.org>
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Ping?


