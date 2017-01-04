From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 1/3] scsi: hisi_sas: service v2 hw CQ ISR with tasklet
Date: Wed, 4 Jan 2017 09:18:36 +0800
Message-ID: <a103003d-51a0-eb2f-8a3d-0b75b24634d6@linaro.org>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
 <1483446290-185084-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483446290-185084-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org
List-Id: linux-scsi@vger.kernel.org



On 2017年01月03日 20:24, John Garry wrote:
> Currently the all the slot processing for the completion
> queue is done in ISR context. It is judged that the slot
> processing can take a long time, especially when a SATA
> NCQ completes (upto 32 slots).
>
> So, as a solution, defer the bulk of the ISR processing
> to tasklet context. Each CQ will have its down tasklet.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>
