From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH v4 3/3] scsi: ufs-bsg: Allow reading descriptors
Date: Mon, 28 Jan 2019 10:42:26 -0800
Message-ID: <CAE=gft6mLsW-iEBZ9pFRWWyDQz_gCs20_4JBoBzxL1tYv0rbYg@mail.gmail.com>
References: <1548572868-12589-1-git-send-email-avri.altman@wdc.com> <1548572868-12589-4-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548572868-12589-4-git-send-email-avri.altman@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 26, 2019 at 11:08 PM Avri Altman <avri.altman@wdc.com> wrote:
>
> Add this functionality, placing the descriptor being read in the actual
> data buffer in the bio.
>
> That is, for both read and write descriptors query upiu, we are using
> the job's request_payload.  This in turn, is mapped back in user land to
> the applicable sg_io_v4 xferp: dout_xferp for write descriptor,
> and din_xferp for read descriptor.
>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Evan Green <evgreen@chromium.org>
