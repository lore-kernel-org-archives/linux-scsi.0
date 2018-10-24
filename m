From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC][PATCH v2] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Tue, 23 Oct 2018 23:09:53 -0400
Message-ID: <yq14ldcf3b2.fsf@oracle.com>
References: <1540254710-26936-1-git-send-email-john.stultz@linaro.org>
        <yq1d0s0f4cm.fsf@oracle.com>
        <CALAqxLX7d8adR6x14EbdhySE1SuoeFwxj6BFG=zitUKZEs75Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAqxLX7d8adR6x14EbdhySE1SuoeFwxj6BFG=zitUKZEs75Tg@mail.gmail.com>
        (John Stultz's message of "Tue, 23 Oct 2018 20:02:36 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, lkml <linux-kernel@vger.kernel.org>, Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>
List-Id: linux-scsi@vger.kernel.org


John,

> Ok. Yea, I saw something similar in the qcom code, but I wasn't sure
> if folks would want host specific quirks isolated to host code.

Yeah, that's why I thought it would be good for the UFS folks to chime
in.

-- 
Martin K. Petersen	Oracle Linux Engineering
