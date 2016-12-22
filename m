From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Thu, 22 Dec 2016 23:00:59 +0100
Message-ID: <20161222230059.000006e1@gmx.de>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54534 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756837AbcLVWBx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 17:01:53 -0500
In-Reply-To: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> Deprecate lpfc_soft_wwn parameter.
> No longer allow override of hw-assigned wwns
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>

Any reason to remove this functionality?
I was actually using it.

Sebastian
