From: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH v2] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Tue, 23 Oct 2018 20:02:36 -0700
Message-ID: <CALAqxLX7d8adR6x14EbdhySE1SuoeFwxj6BFG=zitUKZEs75Tg@mail.gmail.com>
References: <1540254710-26936-1-git-send-email-john.stultz@linaro.org> <yq1d0s0f4cm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d0s0f4cm.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 23, 2018 at 7:47 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> John,
>
> Thanks for tweaking this.
>
>> Not sure if this is the preferred way of scoping the quirk to
>> the controller or not. Feedback would be greatly appreciated!
>
> I think my preference would be to add:
>
>        UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1",
>                 UFS_DEVICE_QUIRK_HOST_VS_DEBUG),
>
> to ufs_fixups[] and then key off of that in the driver. That's how we do
> it in SCSI but the UFS folks may have a different opinion.

Ok. Yea, I saw something similar in the qcom code, but I wasn't sure
if folks would want host specific quirks isolated to host code.

I appreciate the clarification, I'll rework and respin it here shortly.

Thanks again!
-john
