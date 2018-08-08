From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH] scsi: ufs: Check workqueue exists before destroying it
Date: Tue, 07 Aug 2018 23:24:50 -0700
Message-ID: <153370949062.220756.17724147096194635522@swboyd.mtv.corp.google.com>
References: <20180802001435.116963-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802001435.116963-1-mka@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Matthias Kaehlcke <mka@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Quoting Matthias Kaehlcke (2018-08-01 17:14:35)
> In ufshcd_hba_exit() the clock gating workqueue is always destroyed
> when clock gating is supported. However the workqueue pointer is NULL
> when ufshcd_init() fails before the workqueue is created. Only destroy
> the workqueue if it exists.
> =

> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Any sort of Fixes: tag?
