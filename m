From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination (v4)
Date: Sat, 12 Nov 2016 10:29:49 -0500
Message-ID: <yq1inrsk976.fsf@sermon.lab.mkp.net>
References: <20161110135443.GA28767@kroah.com>
        <1478788527-7372-1-git-send-email-andrey2805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1478788527-7372-1-git-send-email-andrey2805@gmail.com> (Andrey
        Grodzovsky's message of "Thu, 10 Nov 2016 09:35:27 -0500")
Sender: stable-owner@vger.kernel.org
To: Andrey Grodzovsky <andrey2805@gmail.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, igor@media-clone.com, ezra@media-clone.com, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Andrey" == Andrey Grodzovsky <andrey2805@gmail.com> writes:

Andrey,

Andrey> Problem: This is a work around for a bug with LSI Fusion MPT
Andrey> SAS2 when pefroming secure erase. Due to the very long time the
Andrey> operation takes commands issued during the erase will time out
Andrey> and will trigger execution of abort hook. Even though the abort
Andrey> hook is called for the specific command which timed out this
Andrey> leads to entire device halt (scsi_state terminated) and
Andrey> premature termination of the secured erase.

This patch didn't apply to the SCSI tree. I merged it into
4.9/scsi-fixes by hand.

Also, please check Documentation/SubmittingPatches for future
submissions. Patch version goes inside the [PATCH foo/bar] brackets and
patch changelog entries below "---" separator.

Thanks!
Martin

-- 
Martin K. Petersen	Oracle Linux Engineering
