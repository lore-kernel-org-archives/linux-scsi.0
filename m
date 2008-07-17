From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/8] scsi_dh: Implement common device table handling
Date: Thu, 17 Jul 2008 12:20:59 -0500
Message-ID: <1216315259.5515.38.camel@localhost.localdomain>
References: <20080717073804.588C518C6FD@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42986 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbYGQRVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 13:21:04 -0400
In-Reply-To: <20080717073804.588C518C6FD@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-07-17 at 09:38 +0200, Hannes Reinecke wrote:
> Instead of having each and every driver implement its own
> device table scanning code we should rather implement a common
> routine and scan the device tables there.
> This allows us also to implement a general notifier chain
> callback for all device handler instead for one per handler.

This doesn't apply against linus head:

Applying scsi_dh: Implement common device table handling
error: patch failed: drivers/scsi/device_handler/scsi_dh_emc.c:412
error: drivers/scsi/device_handler/scsi_dh_emc.c: patch does not apply
error: patch failed: drivers/scsi/device_handler/scsi_dh_hp_sw.c:108
error: drivers/scsi/device_handler/scsi_dh_hp_sw.c: patch does not apply
error: patch failed: drivers/scsi/device_handler/scsi_dh_rdac.c:590
error: drivers/scsi/device_handler/scsi_dh_rdac.c: patch does not apply

It looks like a conflict with this:

commit 33af79d12e0fa25545d49e86afc67ea8ad5f2f40
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Wed Jul 16 17:35:08 2008 -0700

    scsi_dh: Verify "dev" is a sdev before accessing it.

James


