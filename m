From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 1/1] scsi: ufs: make UFS Tx lane1 clock optional for QCOM platforms
Date: Mon, 15 Oct 2018 22:56:22 -0400
Message-ID: <yq1ftx6wqeh.fsf@oracle.com>
References: <1539397502-30120-1-git-send-email-cang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539397502-30120-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Fri, 12 Oct 2018 19:25:02 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Can Guo <cang@codeaurora.org>
Cc: dianders@chromium.org, subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, evgreen@chromium.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Can,

> Per Qcom's UFS host controller HW design, the UFS Tx lane1 clock could
> be muxed with Tx lane0 clock, hence keep Tx lane1 clock optional by
> ignoring it if it is not provided in device tree. This change also
> performs some cleanup to lanes per direction checks when
> enable/disable lane clocks just for symmetry.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
