From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] fcoe: VN2VN target mode fixes
Date: Wed, 13 Jul 2016 22:11:33 -0400
Message-ID: <yq1furdm0iy.fsf@sermon.lab.mkp.net>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38781 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbcGNCLr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 22:11:47 -0400
In-Reply-To: <1467620963-67047-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Mon, 4 Jul 2016 10:29:17 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, When setting up a VN2VN FCoE target there is no real
Hannes> need to run fcoeadm, especially if DCB is disabled.  So this
Hannes> patchset implements a VIP VLAN responder which can be enabled by
Hannes> writing to the sysfs attribute 'fip_vlan_responder'.
Hannes> Additionally there are some fixes for VN2VN mode, most notably
Hannes> the multicast address update when changing modes.

Applied patches 1-4 to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
