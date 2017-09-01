From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2 2/2] scsi: sd: Use sectors_to_logical()
Date: Thu, 31 Aug 2017 23:24:13 -0400
Message-ID: <yq1y3pzumn6.fsf@oracle.com>
References: <20170901010729.16524-1-damien.lemoal@wdc.com>
        <20170901010729.16524-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48795 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbdIADYZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 23:24:25 -0400
In-Reply-To: <20170901010729.16524-3-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 1 Sep 2017 10:07:29 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>


Damien,

> Replace open coded conversions.

I have a pending sd.c cleanup that already does this. I may slip your
patch in and rework my series on top of it. We'll see.

-- 
Martin K. Petersen	Oracle Linux Engineering
