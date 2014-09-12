From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Thu, 11 Sep 2014 21:35:18 -0400
Message-ID: <yq1k3594o4p.fsf@sermon.lab.mkp.net>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
	<1409254292-2540-15-git-send-email-martin.petersen@oracle.com>
	<540390FF.2040703@dev.mellanox.co.il>
	<yq1bnqn9fzg.fsf@sermon.lab.mkp.net>
	<54114AA3.2090806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27144 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaILBfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 21:35:32 -0400
In-Reply-To: <54114AA3.2090806@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Thu, 11 Sep 2014 10:09:23 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, axboe@fb.com, hch@lst.de, sagig@mellanox.com

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi,

Sagi> That's still a dependence on prot_type (type 0...). Notice that
Sagi> you set SCSI_PROT_REF_INCREMENT in every op index (except
Sagi> SCSI_PROT_NORMAL) so my point is that it's strange to see this
Sagi> association.

I still don't understand your point. The mask table indicates which
flags are valid for a given protection operation. They are explicitly
DIX flags and have nothing to do with the target protection type.

Sagi> P.S.  Now drivers can stop understanding prot_type to set DIF
Sagi> operations...  so once drivers stop referencing it we can remove
Sagi> it from scsi_cmnd.

Yes. Second part of this installment removes this and a few other things
and converts qla2xxx, lpfc, mptNsas, etc. to the new interface.

-- 
Martin K. Petersen	Oracle Linux Engineering
