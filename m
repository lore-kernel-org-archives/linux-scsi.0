From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v5 2/2] scsi: ufs: Remove unused device quirks
Date: Tue, 26 Feb 2019 09:14:35 -0800
Message-ID: <CAE=gft5VNr58yzp82GOAmLDGReRUaY3ZGp8aeRc0yRrF3WTW3g@mail.gmail.com>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr> <43265449-30e1-d514-3ffd-fc38530dac67@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <43265449-30e1-d514-3ffd-fc38530dac67@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 11, 2019 at 5:36 AM Marc Gonzalez <marc.w.gonzalez@free.fr> wrote:
>
> The UFSHC driver defines a few quirks that are not used anywhere:
>
> UFS_DEVICE_QUIRK_BROKEN_LCC
> UFS_DEVICE_NO_VCCQ
> UFS_DEVICE_QUIRK_NO_LINK_OFF
> UFS_DEVICE_NO_FASTAUTO
>
> Let's remove them.
>
> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>

Whoops, I lost track of this. Thanks for cleaning this up, Marc.

Reviewed-by: Evan Green <evgreen@chromium.org>
