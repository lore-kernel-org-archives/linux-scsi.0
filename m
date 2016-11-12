From: Andrey Grodzovsky <andrey2805@gmail.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination (v4)
Date: Sat, 12 Nov 2016 11:36:09 -0500
Message-ID: <CAJphD_rAW+fmJq3dK8-a-fpDOdMcLk2t0dUGVUrowXFQ=jA08A@mail.gmail.com>
References: <20161110135443.GA28767@kroah.com> <1478788527-7372-1-git-send-email-andrey2805@gmail.com>
 <yq1inrsk976.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1inrsk976.fsf@sermon.lab.mkp.net>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Igor Rybak <igor@media-clone.com>, Ezra Kohavi <ezra@media-clone.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 12, 2016 at 10:29 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Andrey" == Andrey Grodzovsky <andrey2805@gmail.com> writes:
>
> Andrey,
>
> Andrey> Problem: This is a work around for a bug with LSI Fusion MPT
> Andrey> SAS2 when pefroming secure erase. Due to the very long time the
> Andrey> operation takes commands issued during the erase will time out
> Andrey> and will trigger execution of abort hook. Even though the abort
> Andrey> hook is called for the specific command which timed out this
> Andrey> leads to entire device halt (scsi_state terminated) and
> Andrey> premature termination of the secured erase.
>
> This patch didn't apply to the SCSI tree. I merged it into
> 4.9/scsi-fixes by hand.

Sorry about that and thanks. Next time i will work of off latest tree.
Regarding older code where there is still a separate mpt2sas driver, should
a separate patch to be done or this fix will be ported there ?

Thanks,
Andrey
>
> Also, please check Documentation/SubmittingPatches for future
> submissions. Patch version goes inside the [PATCH foo/bar] brackets and
> patch changelog entries below "---" separator.
>
> Thanks!
> Martin
>
> --
> Martin K. Petersen      Oracle Linux Engineering
