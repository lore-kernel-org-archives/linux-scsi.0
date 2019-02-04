From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v3 5/5] Revert "scsi: ufs: disable vccq if it's not
 needed by UFS device"
Date: Mon, 4 Feb 2019 12:27:04 -0800
Message-ID: <20190204202704.GA31919@minitux>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
 <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
 <SN6PR04MB49255ADE41BBD35F894FD4CBFC6D0@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <SN6PR04MB49255ADE41BBD35F894FD4CBFC6D0@SN6PR04MB4925.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon 04 Feb 11:51 PST 2019, Avri Altman wrote:

> 
> > This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
> > 
> > Calling ufshcd_set_vccq_rail_unused hangs my system.
> > It seems vccq is not *not* needed.
> This patch essentially implements the UFS_DEVICE_NO_VCCQ quirk,
> Which is needed for both Samsung and Hynix devices.
> Once acked by those vendors, can be removed from the quirk list as well.
> 

If a device does not need VCCQ, for some reason, then why is the VCCQ
supply specified for this device?

Disabling unused regulators is already handled by the regulator
framework, so why does the UFSHCD driver take this role as well?

Regards,
Bjorn
