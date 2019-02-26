From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Tue, 26 Feb 2019 16:30:09 +0100
Message-ID: <026c10b1-48e8-ab9f-fda8-6e3557b841a7@free.fr>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
 <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr> <yq1ftsad2yi.fsf@oracle.com>
 <b7f37c2d-27c7-9b58-20c8-52624783a6fa@free.fr> <yq1bm2yd2kr.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1bm2yd2kr.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Hannes Reinecke <hare@suse.de>, Kyuho Choi <kyuho.choi@sk.com>
List-Id: linux-scsi@vger.kernel.org

[ Drop codeaurora.org devs ]

On 26/02/2019 15:52, Martin K. Petersen wrote:

>>>> Revert the original patch, and clean up loose ends in the next patch.
>>>
>>> This commit isn't a revert. Why not?
>>
>> What do you mean?
> 
> Your commit states it reverts the original patch but the submission is
> not a git revert. If there are reasons why simply reverting the original
> commit didn't work, I'd like to see them documented in the commit
> message.

Martin,

I indeed started off from 'git revert'

$ git revert 60f0187031c0
warning: inexact rename detection was skipped due to too many files.
warning: you may want to set your merge.renamelimit variable to at least 18258 and retry the command.
error: could not revert 60f0187031c0... scsi: ufs: disable vccq if it's not needed by UFS device
hint: after resolving the conflicts, mark the corrected paths
hint: with 'git add <paths>' or 'git rm <paths>'
hint: and commit the result with 'git commit'

So I had to resolve the conflict in ufshcd_probe_hba()

The line:

	ufs_advertise_fixup_device(hba);

was modified by commit 93fdd5ac64bbe80dac6416f048405362d7ef0945


It's not clear to me if you want me to

1) document that there was a conflict
2) change the title of the patch
3) both
4) something else altogether

Regards.
