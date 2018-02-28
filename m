From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs-qcom: add number of lanes for Tx and Rx links
Date: Tue, 27 Feb 2018 21:23:44 -0500
Message-ID: <yq1sh9l4ztb.fsf@oracle.com>
References: <20180227055500.10416-1-cang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180227055500.10416-1-cang@codeaurora.org> (Can Guo's message
        of "Tue, 27 Feb 2018 13:46:17 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Can Guo <cang@codeaurora.org>
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Amit Nischal <anischal@codeaurora.org>, Maya Erez <merez@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Can,

> Different platforms may have different number of lanes for the UFS
> Tx/Rx links. Add parameter to device tree specifying how many lanes
> should be configured for the UFS Tx/Rx links. And don't print err
> message for clocks that are optional, this leads to unnecessary
> confusion about failure.

Does not apply to 4.17/scsi-queue. Please rebase and repost.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
