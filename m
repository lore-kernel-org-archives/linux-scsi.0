From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Tue, 26 Feb 2019 09:52:36 -0500
Message-ID: <yq1bm2yd2kr.fsf@oracle.com>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
        <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr>
        <yq1ftsad2yi.fsf@oracle.com>
        <b7f37c2d-27c7-9b58-20c8-52624783a6fa@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b7f37c2d-27c7-9b58-20c8-52624783a6fa@free.fr> (Marc Gonzalez's
        message of "Tue, 26 Feb 2019 15:45:58 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


Marc,

>>> Revert the original patch, and clean up loose ends in the next patch.
>> 
>> This commit isn't a revert. Why not?
>
> What do you mean?

Your commit states it reverts the original patch but the submission is
not a git revert. If there are reasons why simply reverting the original
commit didn't work, I'd like to see them documented in the commit
message.

-- 
Martin K. Petersen	Oracle Linux Engineering
