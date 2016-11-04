From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 09/12] ufs-qcom: phy/hcd: Refactoring phy clock handling
Date: Fri, 04 Nov 2016 12:29:27 -0400
Message-ID: <yq1oa1vw6mw.fsf@sermon.lab.mkp.net>
References: <CAFp+6iGiQG2BV0W0rFKEW6YnEWDkjOqoruJ-neTjKjfKx7yVdA@mail.gmail.com>
        <1478194250-19132-1-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1478194250-19132-1-git-send-email-vivek.gautam@codeaurora.org>
        (Vivek Gautam's message of "Thu, 3 Nov 2016 23:00:50 +0530")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Vivek" == Vivek Gautam <vivek.gautam@codeaurora.org> writes:

Vivek> Add phy clock enable code to phy_power_on/off callbacks, and
Vivek> remove explicit calls to enable these phy clocks from the
Vivek> ufs-qcom hcd driver.

Vivek: I tried to apply v3 with the revised patch 9/12 but that didn't
fly. Please send a v5 series against 4.10/scsi-queue with the review
tags from Subhash applied.

Subhash and others: Please make sure you put your Reviewed-by: tags on a
separate line. There were a few patches that had "LGTM, Reviewed-by:..."
and patchwork sadly does not pick those up.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
