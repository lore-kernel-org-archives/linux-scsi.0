From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC][PATCH v2] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Tue, 23 Oct 2018 22:47:21 -0400
Message-ID: <yq1d0s0f4cm.fsf@oracle.com>
References: <1540254710-26936-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540254710-26936-1-git-send-email-john.stultz@linaro.org> (John
        Stultz's message of "Mon, 22 Oct 2018 17:31:50 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>
List-Id: linux-scsi@vger.kernel.org


John,

Thanks for tweaking this.

> Not sure if this is the preferred way of scoping the quirk to
> the controller or not. Feedback would be greatly appreciated!

I think my preference would be to add:

       UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1",
                UFS_DEVICE_QUIRK_HOST_VS_DEBUG),

to ufs_fixups[] and then key off of that in the driver. That's how we do
it in SCSI but the UFS folks may have a different opinion.

-- 
Martin K. Petersen	Oracle Linux Engineering
