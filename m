From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] fcoe: implement FIP VLAN responder
Date: Wed, 20 Jul 2016 19:50:31 -0400
Message-ID: <yq1zipbeuns.fsf@sermon.lab.mkp.net>
References: <1468928980-40549-1-git-send-email-hare@suse.de>
	<1468928980-40549-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbcGTXvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 19:51:46 -0400
In-Reply-To: <1468928980-40549-2-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Tue, 19 Jul 2016 13:49:40 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jth@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> When running in VN2VN mode there is no central instance which
Hannes> would send out any FIP VLAN discovery notifications. So this
Hannes> patch adds a new sysfs attribute 'fip_vlan_responder' which will
Hannes> activate a FIP VLAN discovery responder.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
