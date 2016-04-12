From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] zfcp: Revert to original scanning behaviour
Date: Mon, 11 Apr 2016 22:14:22 -0400
Message-ID: <yq11t6b1sld.fsf@sermon.lab.mkp.net>
References: <1460096094-126214-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17826 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbcDLCOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 22:14:43 -0400
In-Reply-To: <1460096094-126214-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 8 Apr 2016 08:14:54 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> zfcp has its own mechanism for selective scanning, so revert to
Hannes> the original scanning behaviour to not confuse users.

Benjamin?

-- 
Martin K. Petersen	Oracle Linux Engineering
