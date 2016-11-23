From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 05/11] hisi_sas: replace WARN_ON() with dev_warn() for
 internal abort
Date: Wed, 23 Nov 2016 16:57:34 +0800
Message-ID: <CAMj5Bki25eYbxLsLMmCam0WYaWG1D_ZuM2xEWvtgWA4ocfRnZw@mail.gmail.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com> <1478522920-108145-6-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-6-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> Replace WARN_ON() with dev_warn() print when internal abort fails.
>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Sorry, miss this one.
