From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v3 5/5] Revert "scsi: ufs: disable vccq if it's not needed
 by UFS device"
Date: Tue, 5 Feb 2019 18:51:45 +0100
Message-ID: <7610c262-1451-9bb2-48a6-4daf6f534f6c@free.fr>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
 <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
 <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
 <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
 <05d2d193-4181-12ce-b4fb-4e8dec5aef27@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <05d2d193-4181-12ce-b4fb-4e8dec5aef27@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/02/2019 18:24, Marc Gonzalez wrote:

> /*** system hangs here for several seconds, then reboots ***/

Silly me. The system crashes in ufshcd_dump_regs() which is a bug
I fixed myself. Once I cherry-pick the appropriate fix, the board
no longer reboots, but UFS init does fail.

Full boot log here:
https://pastebin.ubuntu.com/p/KwpRnWMFw5/

In any case, it's obvious that disabling vccq on this system is
a mistake. How would you solve the problem? (A quirk on top of a
quirk sounds silly.)

Regards.
