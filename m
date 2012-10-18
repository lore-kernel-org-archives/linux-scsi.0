From: Venkatraman S <svenkatr@ti.com>
Subject: Re: [PATCH V4 1/4] [SCSI] drivers/scsi/ufs: Seggregate PCI Specific
 Code
Date: Thu, 18 Oct 2012 12:13:58 +0530
Message-ID: <507FA52E.9050400@ti.com>
References: <1350474822-7315-1-git-send-email-vinholikatti@gmail.com> <1350474822-7315-2-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350474822-7315-2-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 17 October 2012 05:23 PM, Vinayak Holikatti wrote:
> This patch seggregates the PCI specific code in ufshcd.c to make it
> ready for splitting into core ufs driver and PCI glue driver. Also
> copyright header modification to remove extra warranty disclaim.
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> ---
>   drivers/scsi/ufs/Kconfig  |   50 +++----
>   drivers/scsi/ufs/ufs.h    |   42 ++----
>   drivers/scsi/ufs/ufshcd.c |  358 ++++++++++++++++++++++++++-------------------
>   drivers/scsi/ufs/ufshci.h |   42 ++----
>   4 files changed, 256 insertions(+), 236 deletions(-)
>
This doesn't apply on 3.7-rc1. Am I missing any patches in between ?
