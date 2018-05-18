From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] Fix UFS and devfreq interaction
Date: Fri, 18 May 2018 11:25:12 -0400
Message-ID: <yq136ypgf53.fsf@oracle.com>
References: <20180518062638.31777-1-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518062638.31777-1-bjorn.andersson@linaro.org> (Bjorn
        Andersson's message of "Thu, 17 May 2018 23:26:35 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <andy.gross@linaro.org>, MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-soc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


Bjorn,

> With the introduction of f1d981eaecf8 ("PM / devfreq: Use the
> available min/max frequency") the UFS host controller driver (UFSHCD)
> stopped probing for platforms that supports frequency scaling,
> e.g. all modern Qualcomm platforms.

Applied to 4.18/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
