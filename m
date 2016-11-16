From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: [PATCH 07/11] hisi_sas: delete repeated configuration in free_device_v2_hw()
Date: Wed, 16 Nov 2016 09:43:54 +0800
Message-ID: <CAMj5Bkj+s_5HeJjHp8=zf4V2ZOEiJ+y34idV7Bedhf6fgMfWAw@mail.gmail.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com> <1478522920-108145-8-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-8-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 7, 2016 at 8:48 PM, John Garry <john.garry@huawei.com> wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> Delete repeated configuration items for hisi_sas_device() when
> we free a device. These items are now only set in
> hisi_sas_dev_gone().
>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>

Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
