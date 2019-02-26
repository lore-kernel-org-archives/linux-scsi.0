From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Tue, 26 Feb 2019 15:45:58 +0100
Message-ID: <b7f37c2d-27c7-9b58-20c8-52624783a6fa@free.fr>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
 <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr> <yq1ftsad2yi.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ftsad2yi.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Ya
List-Id: linux-scsi@vger.kernel.org

On 26/02/2019 15:44, Martin K. Petersen wrote:

> Hi Marc,
> 
>> Commit 60f0187031c0 ("disable vccq if it's not needed by UFS device")
>> introduced a small power optimization as a driver quirk: ignore the
>> vccq load specified in the UFSHC DT node when said host controller
>> is connected to specific Flash chips (Samsung and Hynix currently).
> 
> [...]
> 
>> Revert the original patch, and clean up loose ends in the next patch.
> 
> This commit isn't a revert. Why not?

What do you mean?
