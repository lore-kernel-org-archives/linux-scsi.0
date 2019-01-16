From: John Stultz <john.stultz@linaro.org>
Subject: Re: ufshcd_queuecommand() triggering after ufshcd_suspend()?
Date: Wed, 16 Jan 2019 14:14:09 -0800
Message-ID: <CALAqxLXhR2Fny4L4wqEHnZ+w0ktTp=ntvxuPU8h-vLwZW51k0Q@mail.gmail.com>
References: <CALAqxLURfQcSy2w7F7NCPtGaChka4U5LmvufLd0VZ73S=AzHkA@mail.gmail.com>
 <SN6PR04MB4925CA2AFE5F060469E6F018FC850@SN6PR04MB4925.namprd04.prod.outlook.com>
 <20190114032444.GA124121@hisi.inhuawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190114032444.GA124121@hisi.inhuawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: Avri Altman <Avri.Altman@wdc.com>, Sahitya Tummala <stummala@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Wei Li <liwei213@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Evan Green <evgreen@chromium.org>, Vijay Viswanath <vviswana@codeaurora.org>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 13, 2019 at 7:25 PM Zang Leigang <zangleigang@hisilicon.com> wrote:
>   I think there are two different issues:
>
>   1. clk_gating's state(including state's trace event) and is_suspended is not
>      wrapped by ufshcd_is_clkgating_allowed which Hisilicon's kirin platoform
>      soc does not need but is set and checked in a regular path.
>   2. I think SCSI is necessary to block queue to stop sending to ufs after
>      system suspend or, add a new state for ufs like UFSHCD_STATE_SUSPENDING
>      or what else. hba->is_sys_suspended is too late to stop ufshcd_queuecommand
>

Hey Zang,
  Thanks for the suggestions. I'm not sure I have enough context to
try to come up with a patch. I'll try to take a stab at it, but I'd
appreciate it if  you have any more specific suggestions or patches
for me to try. :)

thanks
-john
