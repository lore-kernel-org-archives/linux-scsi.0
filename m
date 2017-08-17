From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/4] scsi: Fixup ses page check
Date: Wed, 16 Aug 2017 20:24:11 -0400
Message-ID: <yq1378rqbx0.fsf@oracle.com>
References: <1502785303-41870-1-git-send-email-hare@suse.de>
        <1502785303-41870-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35218 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbdHQAZX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:25:23 -0400
In-Reply-To: <1502785303-41870-2-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 15 Aug 2017 10:21:40 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> The error code from a scsi_execute_req() is a SCSI status, not
> a normal errno. So whenever it returns a value here an error
> occurred and there's no point in looking at the page number.

424f727b9413 scsi: ses: Fix wrong page error

-- 
Martin K. Petersen	Oracle Linux Engineering
