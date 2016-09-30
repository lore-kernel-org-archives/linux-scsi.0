From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] UFS: Date Segment only need for WRITE DESCRIPTOR
Date: Thu, 29 Sep 2016 21:36:24 -0400
Message-ID: <yq1d1jmw4mf.fsf@sermon.lab.mkp.net>
References: <20160825093919.5936-1-zangleigang@hisilicon.com>
        <9e470819d1cfcead5966e37c00f53967@codeaurora.org>
        <CGME20160928051454epcas2p3ad585ef9c23a18aacfdaabea15afbf6e@epcas2p3.samsung.com>
        <yq1intgy5at.fsf@sermon.lab.mkp.net>
        <007b01d2194a$4f3567a0$eda036e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <007b01d2194a$4f3567a0$eda036e0$@samsung.com> (Kiwoong Kim's
        message of "Wed, 28 Sep 2016 14:36:49 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: "'Martin K. Petersen'" <martin.petersen@oracle.com>, subhashj@codeaurora.org, 'Zang Leigang' <zangleigang@hisilicon.com>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kiwoong" == Kiwoong Kim <kwmad.kim@samsung.com> writes:

Kiwoong> I think that the patch is correct.  UFS spec says "The Data
Kiwoong> Segment area is empty" for Read Descriptor.  I have been using
Kiwoong> similar code with it and it works.  That have been already
Kiwoong> applied in Android kernel.

That's fine. Just checking.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
