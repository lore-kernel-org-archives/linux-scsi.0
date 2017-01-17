From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 00/10] qla2xxx: Bug fixes for driver.
Date: Tue, 17 Jan 2017 10:06:03 -0800
Message-ID: <c9fca4ec-1837-3fc7-d7bb-c2e00460a698@sandisk.com>
References: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482545174-811-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/23/2016 06:06 PM, Himanshu Madhani wrote:
> Hi Bart,
> 
> Here's updated series of bug fixes for target code in the driver.
> Please consider this for target-pending.

Hello Himanshu,

Thanks for the patches. I have queued these patches for v4.10-rc5. But
since the qla2xxx driver code triggers several static checker warnings,
I would appreciate if you could have a look at the four patches I just
posted to address these warnings.

Bart.
