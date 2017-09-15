From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] sg: factor out sg_fill_request_table()
Date: Fri, 15 Sep 2017 15:24:00 -0400
Message-ID: <yq1poarpxyn.fsf@oracle.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
        <1505477116-75013-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31273 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbdIOTZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 15:25:03 -0400
In-Reply-To: <1505477116-75013-2-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 15 Sep 2017 14:05:15 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> Factor our sg_fill_request_table() for better readability.

         ^^^ out

Fixed typo and applied to 4.14/scsi-fixes. I had to do it by hand so
please check.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
