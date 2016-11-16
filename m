From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 10/11] hisi_sas: use atomic64_t for hisi_sas_device.running_req
Date: Wed, 16 Nov 2016 09:44:26 +0800
Message-ID: <CAMj5BkjopJ6tGx=HV7LExZ9BNZhUrMN9T2r_Z63BooBbCetwDQ@mail.gmail.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com> <1478522920-108145-11-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-11-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
> Sometimes the value of hisi_sas_device.running_req
> would go negative unless we have the check for
> running_req >= 0 before trying to decrement.
>
> This is because using running_req is not thread-safe.
>
> As such, the value for running_req may be actually incorrect,
> so use atomic64_t instead.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>

Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
