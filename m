From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH] block: Fix possible sleep in invalid context
Date: Tue, 02 Jul 2013 08:57:52 +0530
Message-ID: <51D248B8.3030701@codeaurora.org>
References: <1372692515-31969-1-git-send-email-sthumma@codeaurora.org> <51D24336.5020504@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <51D24336.5020504@intel.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On 7/2/2013 8:34 AM, Aaron Lu wrote:
>> Fix this by releasing spin_lock_irq() before calling
>> >pm_runtime_autosuspend() in blk_post_runtime_resume().
> Hi Sujit,
>
> Thanks for testing out block layer runtime PM!
>
> As for the problem here, it is already fixed by:
>
> commit c60855cdb976c632b3bf8922eeab8a0e78edfc04
> Author: Aaron Lu<aaron.lu@intel.com>
> Date:   Fri May 17 15:47:20 2013 +0800
>
>      blkpm: avoid sleep when holding queue lock

Thanks Aaron. I see that is merged in 3.10-rc6.
Please ignore this patch.

-- 
Regards,
Sujit
