From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [trivial] pm8001: Fix typo in pm8001_hwi.c
Date: Thu, 02 Feb 2012 09:00:04 -0800
Message-ID: <1328202004.18641.28.camel@joe2Laptop>
References: <1328191660-2037-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328191660-2037-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: jack_wang@usish.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, trivial@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-02-02 at 23:07 +0900, Masanari Iida wrote:
> Correct typo "deviece" to "device" in
> drivers/scsi/pm8001/pm8001_hwi.c
[]
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
[]
> @@ -3532,7 +3532,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
> []
> -			pm8001_printk("unresgister the deviece\n"));
> +			pm8001_printk("unresgister the device\n"));

another typo of unregister
