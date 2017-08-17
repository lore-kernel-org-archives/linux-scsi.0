From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] ses: simple subenclosure support
Date: Wed, 16 Aug 2017 20:28:44 -0400
Message-ID: <yq1y3qjox4z.fsf@oracle.com>
References: <1502785303-41870-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46632 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdHQA24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:28:56 -0400
In-Reply-To: <1502785303-41870-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 15 Aug 2017 10:21:39 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> some arrays (most notably 3Par) only support simple subenclosures.
> Sadly our ses implementation doesn't handle this properly, so we're
> greeted with error messages like:
>
> scsi 1:0:0:254: Wrong diagnostic page; asked for 2 got 0
> scsi 1:0:0:254: Failed to get diagnostic page 0xffffffea
> scsi 1:0:0:254: Failed to bind enclosure -19
> ses 1:0:0:254: Attached Enclosure device
>
> This patchset fixes up our ses implementation to work properly
> with simple subenclosures.

Looks OK to me. Applied to 4.14/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
