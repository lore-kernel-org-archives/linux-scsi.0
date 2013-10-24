From: Dave Jones <davej@redhat.com>
Subject: strange comparison in be2iscsi
Date: Thu, 24 Oct 2013 04:47:21 -0400
Message-ID: <20131024084721.GA15720@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3JXIrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Oct 2013 04:47:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohank@serverengines.com
Cc: linux-scsi@vger.kernel.org

A few years ago, in 4183122dbc7c489f11971c5afa8e42011bca7fa2
this code was added to drivers/scsi/be2iscsi/be_main.c

+               if (abrt_task->sc->device->lun != abrt_task->sc->device->lun)
+                       continue;

Which doesn't make a lot of sense.
What was the intent here ?

	Dave

