From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] scsi: ufs: Check workqueue exists before destroying it
Date: Thu, 9 Aug 2018 11:57:36 -0700
Message-ID: <20180809185736.GH160295@google.com>
References: <20180802001435.116963-1-mka@chromium.org>
 <153370949062.220756.17724147096194635522@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153370949062.220756.17724147096194635522@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@kernel.org>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 07, 2018 at 11:24:50PM -0700, Stephen Boyd wrote:
> Quoting Matthias Kaehlcke (2018-08-01 17:14:35)
> > In ufshcd_hba_exit() the clock gating workqueue is always destroyed
> > when clock gating is supported. However the workqueue pointer is NULL
> > when ufshcd_init() fails before the workqueue is created. Only destroy
> > the workqueue if it exists.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> 
> Any sort of Fixes: tag?

I could add one, though it seems this patch is superseded by
https://patchwork.kernel.org/patch/10559013/
