From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Use the resource-managed function to add devfreq device
Date: Tue, 08 Nov 2016 19:17:14 -0500
Message-ID: <yq1lgwtpkvp.fsf@sermon.lab.mkp.net>
References: <1478596408-2958-1-git-send-email-cw00.choi@samsung.com>
        <1478596408-2958-3-git-send-email-cw00.choi@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478596408-2958-3-git-send-email-cw00.choi@samsung.com> (Chanwoo
        Choi's message of "Tue, 08 Nov 2016 18:13:28 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, rjw@rjwysocki.net, subhashj@codeaurora.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chanwoo" == Chanwoo Choi <cw00.choi@samsung.com> writes:

Chanwoo> This patch uses the resource-managed to add the devfreq device.
Chanwoo> This function will make it easy to handle the devfreq device.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
