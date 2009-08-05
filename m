From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/7] mptsas : Discription patch
Date: Wed, 5 Aug 2009 12:47:32 +0530
Message-ID: <20090805071722.GA14031@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:35837 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbZHEH5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 03:57:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com



[PATCH 1/7] mptsas : Change DEFINED value of can queue for FC and SAS devices.
[PATCH 2/7] mptsas : Removed mptscsih_timer_expired.
[PATCH 3/7] mptsas : Handle INSUFFICIENT resources status as similar to IOC
BUSY  status.
[PATCH 4/7] mptsas : Change config request timeout value to 30 seconds.
[PATCH 5/7] mptsas : Use max_id to infinite value.
[PATCH 6/7] mptsas : Code cleanup of host page alloc and diag reset.
[PATCH 7/7] mptsas : Bump version to 3.04.11
---
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
