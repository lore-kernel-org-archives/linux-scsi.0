From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] wd719x: Remove last declaration using DEFINE_PCI_DEVICE_TABLE
Date: Fri, 02 Sep 2016 14:05:06 -0400
Message-ID: <yq14m5y2n59.fsf@sermon.lab.mkp.net>
References: <cover.1472660229.git.joe@perches.com>
        <95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com>
        <yq1lgzatwq2.fsf@sermon.lab.mkp.net>
        <20160902101654.4f7e8fd484bfab95444dfe35@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160902101654.4f7e8fd484bfab95444dfe35@linux-foundation.org>
        (Andrew Morton's message of "Fri, 2 Sep 2016 10:16:54 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Perches <joe@perches.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> That creates an ordering dependency between the scsi tree and
Andrew> -mm's "treewide: remove references to the now unnecessary
Andrew> DEFINE_PCI_DEVICE_TABLE".

Andrew> So an ack would be preferred, please.

OK. I was assuming that a subsequent patch would remove the macro.

I'll just drop the patch then.

-- 
Martin K. Petersen	Oracle Linux Engineering
