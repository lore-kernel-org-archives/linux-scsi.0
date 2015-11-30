From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/18] scsi_dh: move 'dh_state' sysfs attribute to generic code
Date: Mon, 30 Nov 2015 11:59:54 -0500
Message-ID: <yq1h9k3ifsl.fsf@sermon.lab.mkp.net>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	<1447081703-110552-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40270 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbbK3RAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2015 12:00:09 -0500
In-Reply-To: <1447081703-110552-2-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Mon, 9 Nov 2015 16:08:06 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> As scsi_dh.c is now always compiled in we should be moving the
Hannes> 'dh_state' attribute to the generic code.

This patch conflicts with 23695e41a1ca ("scsi_dh: fix use-after-free
when removing scsi device").

Looked simple enough and I started to fix it up but then decided to let
you do since you'll have to check it anyway.

Please rebase on top of latest 4.5/scsi-queue (which has your VPD rescan
patch in place).

-- 
Martin K. Petersen	Oracle Linux Engineering
