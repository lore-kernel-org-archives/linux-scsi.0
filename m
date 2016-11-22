From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] ufs: qcom: Properly clear hba priv on failure
Date: Mon, 21 Nov 2016 22:41:16 -0500
Message-ID: <yq1poloyyeb.fsf@sermon.lab.mkp.net>
References: <1479623691-7612-1-git-send-email-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1479623691-7612-1-git-send-email-bjorn.andersson@linaro.org>
        (Bjorn Andersson's message of "Sat, 19 Nov 2016 22:34:51 -0800")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bjorn" == Bjorn Andersson <bjorn.andersson@linaro.org> writes:

Bjorn> ufs_qcom_init() sets the hba priv data before attempting to
Bjorn> acquire the phy handle, so make sure to clear this in the case of
Bjorn> an error. Failing to do this will make ufs_qcom_setup_clocks()
Bjorn> operate on the uninitalized host object.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
