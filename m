From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/8] scsi_dh: Implement common device table handling
Date: Thu, 17 Jul 2008 10:33:10 -0700
Message-ID: <1216315990.27507.254.camel@chandra-ubuntu>
References: <20080717073804.588C518C6FD@pentland.suse.de>
	 <1216315259.5515.38.camel@localhost.localdomain>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45352 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001AbYGQRdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 13:33:24 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6HHXN6T022190
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2008 13:33:23 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6HHXN6n124582
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2008 13:33:23 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6HHXM8L004535
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2008 13:33:23 -0400
In-Reply-To: <1216315259.5515.38.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

James,

I am working on regenerating Hannes's patches based on Linus's latest
git tree (git5) which includes my patch.

Will send it ASAP.

chandra
On Thu, 2008-07-17 at 12:20 -0500, James Bottomley wrote:
> On Thu, 2008-07-17 at 09:38 +0200, Hannes Reinecke wrote:
> > Instead of having each and every driver implement its own
> > device table scanning code we should rather implement a common
> > routine and scan the device tables there.
> > This allows us also to implement a general notifier chain
> > callback for all device handler instead for one per handler.
> 
> This doesn't apply against linus head:
> 
> Applying scsi_dh: Implement common device table handling
> error: patch failed: drivers/scsi/device_handler/scsi_dh_emc.c:412
> error: drivers/scsi/device_handler/scsi_dh_emc.c: patch does not apply
> error: patch failed: drivers/scsi/device_handler/scsi_dh_hp_sw.c:108
> error: drivers/scsi/device_handler/scsi_dh_hp_sw.c: patch does not apply
> error: patch failed: drivers/scsi/device_handler/scsi_dh_rdac.c:590
> error: drivers/scsi/device_handler/scsi_dh_rdac.c: patch does not apply
> 
> It looks like a conflict with this:
> 
> commit 33af79d12e0fa25545d49e86afc67ea8ad5f2f40
> Author: Chandra Seetharaman <sekharan@us.ibm.com>
> Date:   Wed Jul 16 17:35:08 2008 -0700
> 
>     scsi_dh: Verify "dev" is a sdev before accessing it.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

