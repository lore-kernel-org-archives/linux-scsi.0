From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: scsi0: Unexpected busfree while idle - Adaptec 29160N Ultra160 SCSI adapter
Date: Sun, 15 Jul 2007 04:04:50 +0200
Message-ID: <9a8748490707141904w5ddc6e03r97c7f0909067d50@mail.gmail.com>
References: <200707090040.32726.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_50952_1198914.1184465090554"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:47071 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbXGOCEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jul 2007 22:04:51 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1114856wah
        for <linux-scsi@vger.kernel.org>; Sat, 14 Jul 2007 19:04:50 -0700 (PDT)
In-Reply-To: <200707090040.32726.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, jens.axboe@oracle.com, "James E. J. Bottomley" <James.Bottomley@steeleye.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, jesper.juhl@gmail.com

------=_Part_50952_1198914.1184465090554
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 09/07/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> I just experienced a long hang and a lot of unpleasant messages in dmesg
> while building randconfig kernels in a loop.
>

It just happened again without me doing anything special, just normal
desktop use, surfing the net, reading email etc. This time the kernel
version was 2.6.22-g1db6178c

This time the start of the messages look like this (slightly different
from last time - quoted below):

[ 8039.510026] scsi0: Unexpected busfree while idle
[ 8039.510036] SEQADDR == 0x18
[ 8069.492318] sr 0:0:4:0: Attempting to queue an ABORT message
[ 8069.492324] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 8069.492342] scsi0: At time of recovery, card was not paused
[ 8069.492353] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
[ 8069.492357] scsi0: Dumping Card State while idle, at SEQADDR 0x18
[ 8069.492362] Card was paused
[ 8069.492371] ACCUM = 0xa, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x2
[ 8069.492378] HCNT = 0x0 SCBPTR = 0xb
[ 8069.492384] SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0]
[ 8069.492406] SCSIBUSL[0x0] LASTPHASE[0x1] SCSISEQ[0x1a]
[ 8069.492426] SBLKCTL[0xa] SCSIRATE[0x0] SEQCTL[0x10]
[ 8069.492447] SEQ_FLAGS[0xc0] SSTAT0[0x0] SSTAT1[0x0]
[ 8069.492467] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]
[ 8069.492487] SIMODE1[0xa4] SXFRCTL0[0x80] DFCNTRL[0x0]
[ 8069.492507] DFSTATUS[0x89]
[ 8069.492515] STACK: 0x0 0x164 0x179 0x17
[ 8069.492536] SCB count = 24
[ 8069.492540] Kernel NEXTQSCB = 12
[ 8069.492545] Card NEXTQSCB = 17
[ 8069.492549] QINFIFO entries: 17 18
[ 8069.492561] Waiting Queue entries: 11:10
[ 8069.492573] Disconnected Queue entries:
[ 8069.492581] QOUTFIFO entries:
[ 8069.492587] Sequencer Free SCB List: 3 1 13 14 5 6 0 17 10 19 4 8 7
2 16 20 18 12 15 9 21 22 23 24 25
 26 27 28 29 30 31
[ 8069.492694] Sequencer SCB Info:
[ 8069.492698]   0 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492723] SCB_TAG[0xff]
[ 8069.492729]   1 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492753] SCB_TAG[0xff]
[ 8069.492759]   2 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492784] SCB_TAG[0xff]
[ 8069.492791]   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492816] SCB_TAG[0xff]
[ 8069.492822]   4 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492845] SCB_TAG[0xff]
[ 8069.492851]   5 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492875] SCB_TAG[0xff]
[ 8069.492880]   6 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492904] SCB_TAG[0xff]
[ 8069.492910]   7 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492934] SCB_TAG[0xff]
[ 8069.492940]   8 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492964] SCB_TAG[0xff]
[ 8069.492969]   9 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.492994] SCB_TAG[0xff]
[ 8069.493000]  10 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493024] SCB_TAG[0xff]
[ 8069.493030]  11 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0]
[ 8069.493054] SCB_TAG[0xa]
[ 8069.493060]  12 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493085] SCB_TAG[0xff]
[ 8069.493090]  13 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493114] SCB_TAG[0xff]
[ 8069.493120]  14 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493145] SCB_TAG[0xff]
[ 8069.493150]  15 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493175] SCB_TAG[0xff]
[ 8069.493181]  16 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493206] SCB_TAG[0xff]
[ 8069.493212]  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493235] SCB_TAG[0xff]
[ 8069.493241]  18 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493266] SCB_TAG[0xff]
[ 8069.493272]  19 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493296] SCB_TAG[0xff]
[ 8069.493302]  20 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493316] SCB_TAG[0xff]
[ 8069.493323]  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493348] SCB_TAG[0xff]
[ 8069.493354]  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493378] SCB_TAG[0xff]
[ 8069.493383]  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493407] SCB_TAG[0xff]
[ 8069.493413]  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493437] SCB_TAG[0xff]
[ 8069.493443]  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493469] SCB_TAG[0xff]
[ 8069.493475]  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493501] SCB_TAG[0xff]
[ 8069.493507]  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493531] SCB_TAG[0xff]
[ 8069.493537]  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493562] SCB_TAG[0xff]
[ 8069.493568]  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493593] SCB_TAG[0xff]
[ 8069.493599]  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493625] SCB_TAG[0xff]
[ 8069.493631]  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
[ 8069.493656] SCB_TAG[0xff]
[ 8069.493664] Pending list:
[ 8069.493669]  18 SCB_CONTROL[0x40] SCB_SCSIID[0x57] SCB_LUN[0x0]
[ 8069.493687]  17 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
[ 8069.493706]  10 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0]
[ 8069.493727] Kernel Free SCB list: 23 22 3 13 16 1 11 14 2 9 8 5 21
15 19 0 4 7 6 20
[ 8069.493780] Untagged Q(4): 10
[ 8069.493788] Untagged Q(5): 18
[ 8069.493796]
[ 8069.493797] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
[ 8069.493819] scsi0:0:4:0: Cmd aborted from QINFIFO
[ 8069.493892] aic7xxx_abort returns 0x2002
[ 8079.485432] sr 0:0:4:0: Attempting to queue an ABORT message
[ 8079.485438] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 8079.485455] scsi0: At time of recovery, card was not paused
...

The complete dmesg log is attached in gzip'ed form.



> Here's the beginning of the messages (full dmesg output attached)
>
> ...
> [ 9997.057000] scsi0: Unexpected busfree while idle
> [ 9997.057000] SEQADDR == 0x18
> [10030.588000] sr 0:0:5:0: Attempting to queue an ABORT message
> [10030.588000] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> [10030.588000] scsi0: At time of recovery, card was not paused
> [10030.588000] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> [10030.588000] scsi0: Dumping Card State while idle, at SEQADDR 0x18
> [10030.588000] Card was paused
> [10030.588000] ACCUM = 0x4, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x1
> [10030.588000] HCNT = 0x0 SCBPTR = 0xf
> [10030.588000] SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0]
> [10030.588000] SCSIBUSL[0x0] LASTPHASE[0x1] SCSISEQ[0x1a]
> [10030.588000] SBLKCTL[0xa] SCSIRATE[0x0] SEQCTL[0x10]
> [10030.588000] SEQ_FLAGS[0xc0] SSTAT0[0x0] SSTAT1[0x0]
> [10030.588000] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]
> [10030.588000] SIMODE1[0xa4] SXFRCTL0[0x80] DFCNTRL[0x0]
> [10030.588000] DFSTATUS[0x89]
> [10030.588000] STACK: 0x0 0x164 0x179 0x17
> [10030.588000] SCB count = 40
> [10030.588000] Kernel NEXTQSCB = 31
> [10030.588000] Card NEXTQSCB = 0
> [10030.588000] QINFIFO entries: 0 9 28 30 13 19 2 21 25 20 16 17 18 32 34 11 22 7
> [10030.588000] Waiting Queue entries: 15:4
> [10030.588000] Disconnected Queue entries:
> [10030.588000] QOUTFIFO entries:
> [10030.588000] Sequencer Free SCB List: 3 30 19 23 11 16 25 17 18 10 4 6 26 24 7 28 20 27 12 0 2 8 21 14 22 5 1 31 13 29 9
> [10030.588000] Sequencer SCB Info:
> [10030.588000]   0 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   1 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   2 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   4 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   5 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   6 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   7 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   8 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]   9 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  10 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  11 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  12 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  13 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  14 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  15 SCB_CONTROL[0x40] SCB_SCSIID[0x57] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0x4]
> [10030.588000]  16 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  18 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  19 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  20 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  21 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  22 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  23 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  24 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  25 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  26 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  27 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  28 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  29 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  30 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000]  31 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000] SCB_TAG[0xff]
> [10030.588000] Pending list:
> [10030.588000]   7 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  22 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  11 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  34 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  32 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  18 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  17 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  16 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  20 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  25 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  21 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]   2 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  19 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  13 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  30 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]  28 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]   9 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [10030.588000]   0 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0]
> [10030.588000]   4 SCB_CONTROL[0x40] SCB_SCSIID[0x57] SCB_LUN[0x0]
> [10030.588000] Kernel Free SCB list: 24 10 23 5 3 14 33 1 26 15 35 6 29 12 39 27 8 38 37 36
> [10030.588000] Untagged Q(4): 0
> [10030.588000] Untagged Q(5): 4
> [10030.588000]
> [10030.588000] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> [10030.588000] scsi0:0:5:0: Cmd aborted from QINFIFO
> [10030.588000] aic7xxx_abort returns 0x2002
> [10040.588000] sr 0:0:5:0: Attempting to queue an ABORT message
> [10040.588000] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> [10040.588000] scsi0: At time of recovery, card was not paused
> ...
> (see attached file for remaining (long) output)
>
>
> Here's output from scripts/ver_linux :
>
> juhl@dragon:~/kernel/linux-2.6$ scripts/ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux dragon 2.6.22-rc7-g4e99325b #1 SMP PREEMPT Sun Jul 8 21:24:48 CEST 2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD GNU/Linux
>
> Gnu C                  4.1.2
> Gnu make               3.81
> binutils               Binutils
> util-linux             2.12r
> mount                  2.12r
> module-init-tools      3.2.2
> e2fsprogs              1.39
> jfsutils               1.1.11
> reiserfsprogs          3.6.19
> xfsprogs               2.8.16
> pcmciautils            014
> quota-tools            3.13.
> PPP                    2.4.4
> Linux C Library        > libc.2.5
> Dynamic linker (ldd)   2.5
> Linux C++ Library      6.0.8
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.2
> Sh-utils               6.9
> udev                   111
> Modules Loaded         dm_mod snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss agpgart lp snd_emu10k1 snd_rawmidi firmware_class snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem via_rhine snd_hwdep ehci_hcd sg evdev k8temp
>

except for the slightly newer kernel, the above userspace info is still valid.

>
> and here's /proc/scsi/scsi :
>
> juhl@dragon:~/kernel/linux-2.6$ cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 04 Lun: 00
>   Vendor: PIONEER  Model: DVD-ROM DVD-305  Rev: 1.03
>   Type:   CD-ROM                           ANSI  SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 05 Lun: 00
>   Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01
>   Type:   CD-ROM                           ANSI  SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 06 Lun: 00
>   Vendor: IBM      Model: DDYS-T36950N     Rev: S96H
>   Type:   Direct-Access                    ANSI  SCSI revision: 03
>

This scsi info is still valid.

>
> uname -a is :
>
> juhl@dragon:~/kernel/linux-2.6$ uname -a
> Linux dragon 2.6.22-rc7-g4e99325b #1 SMP PREEMPT Sun Jul 8 21:24:48 CEST 2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD GNU/Linux
>

This is now :

Linux dragon 2.6.22-g1db6178c #1 SMP PREEMPT Sat Jul 14 04:10:50 CEST
2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD
GNU/Linux

>
> I have a feeling this may be related to my old problem with machine hangs when
> building kernels in a loop that I reported back in 2.6.17-2.6.19 times :
> http://www.webservertalk.com/archive242-2006-11-1692290.html
>
> The problem mentioned in the thread above I can still reliably reproduce. All
> I need to do is use my script to build kernels in a loop and I'll usually get a
> hang within 10 kernels (with recent versions) or 100 kernels (with pre-2.6.20
> kernels).
> One difference between the hangs I've seen previously and this one is that
> previously I've always use "nice make -j 3" when building the kernels, but
> this time I edited my script to use just "nice make", thus only using a single
> core. I suspect this is why my box stayed resonably alive this time - enough
> for me to be able to capture some dmesg output - instead of just hanging
> completely like it usually does.
>
> If any further information is required, just let me know and I'll be happy to
> provide it.
> Any patches you want me to test, just send them my way :-)
>
> Getting this finally resolved would be *very* nice :-)
>
>
> (please note that I'm not subscribed to linux-scsi, so please keep me on Cc)
>

It seems that since 2.6.22-rc<mid/late-ish> this is getting more
frequent, but that's just a subjective feeling, quite vague...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

------=_Part_50952_1198914.1184465090554
Content-Type: application/x-gzip; name=dmesg-2.6.22-g1db6178c.txt.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f44vrl1x
Content-Disposition: attachment; filename="dmesg-2.6.22-g1db6178c.txt.gz"

H4sICAZ9mUYCA2RtZXNnLTIuNi4yMi1nMWRiNjE3OGMudHh0AMRcbXPjNpL+fr+ib/MhdmLJAPiu
Km+dLNtj3Vi21tIkezvnUlEkZDOmSS1J+SWVH3/dIClSb6Y8k93TTDyy1P3gQQPdaADNfAV8sTZT
rzu4CqLFKzzLJA3iCETbbAvRuuf+1OSW7cHBb4uH8L/8xL2Po0M4uPe8paze5m1xCD9wGA2GMLw9
Px8MxzByM/jvRQhcB6Z3OOsYDHrnozEIxqz/+Lra+Gn/ZtSaJ/Fz4Esf5g9vaeC5Idx2B/Dkzjvr
4rm8tAXrAFt7Qav+kTOz8aODRepOQ3m4J06utILjKuiDRKYyeZb+vkjSXmfE2Tch8fW+WbPZNEf6
QN+WSis4Xo7T7Q374LuZuy+Utwk1q0Fd/zLaF2m2hmSXY/kxM81m1honzpqRODf44BQu+58uB+cD
cJ/dICSLttcFbcdEuaubX98Xm8WLyFeuMBi2MhIBdIWcns3Wpc+jTCZBdA+u709cLwue5SRxo3t5
wI4A/xpCF8w+BAYyypJAphDPQBgmLFLpr4P9I44kDC+uQSGkm34DZ4Mu1F9oq7+qNzpzzE3x6zh5
Qj+EpUguLoSjWVvEL4P7h4F8gqVILp73YV1cukn4NoliX07Qx7/yO8i7X+vAZgv4W2eN+3b0mwgI
GoWyOHPDuUv22CGbm+V3NF4HNAFKVtkXxzKBJ/mE/N7TYYVKOcXek9WZqefiR3DVv7iBqZt5Dx22
0/a5GrdMti+xFUUhNEOwLS1qfPf4Faoa0/Ztc03TEYZw9mr0bNDHxQbbIeNF2YY3USjpwO3obEgu
dOGcnpJfMFxVDhKmvu0ODncqjcG6uDilD0lJozDAoQsD6APcnA+UBHBckZjBTBiMLsbF3HKsHaAX
+E8OKnJQm5iIGqiS+Bjo2ZKpTqC60bUUU3A0ZyDynxzXT/WiN/3r8RXQSiqYMHczHRFor+y+zrYL
dof9Xt665ihB016zk5L4WJdQ67RoXVegGLJqoN1Bf4IiHwQdDlrj4Ekm0L+BYZxk6Hqv9qY/58JX
MaUQijrGVpxeKUrPpFRCO1SU9IHrzYNJ4H9lrwyjUujOA6/4lcJWRCF9cxkZJrGHbaCP/MBwjDpa
3nSZJHFz3ybFapN8ryb5B5rs3+RtLpsrzPOVzOMVovdpMJm6qfzK7jbazQHwmw4UREEcVc1aRysG
zxGP4NOoD6wltH1IaWuk+Bopoe9kxWustHdY8YqV0Fuas4PW9Xgyuu1Nbn65hYPpAnUBf06C5J/4
7j6Mp26ofhHgz0L67/DDOE4dx4EwfoFQPsudSLd/Y3k8nr5BjN1LMGdu75QVH5B1mmXPaSpSuqJG
6wlXWFyOL0I3awN8SekLAf3jG/X1xvKdC6jk8GDQPRsfqiWFMiUvjmbB/SJxMxqrIJrREkbvN7iG
Ibp1RjjDXp9W3HiRoBNAmrmJ+hhzLdsuk7573DxAmU12rCI/3LDs6SIIM+Bq9QqDNEuxN2NKG2CZ
NzDON2buZ5mgPJLHNRFTPrQLWuP05mY86Q+6n85PVndQSYx/4+zEZhuLIC6pczS8smkWAybEM1/x
L8PV4Q6NwmsKHa/Q8T6gMy11+Fad5XjP3DSDi+EXSF1M0ai7aPssTmS73QYf7bZ7qiyiJzd9xJZH
/cGZwpCvnpyroU4X8zkG8p0g/SjIAjcMfieg3vDLDxuRGz9EZ0LfwRngPWK68eAm/onHDEF7Nkjj
WaZ+s7dE/WH/DMXTB8jT9CLD7uSZ7kGc+DLB1AtjGzc1XOenb5lMN0x0JjPpZdg9gUtZG5MmGFz+
jvlMEZvzLmm4oXYMzbSRcBylcYgzxYtDnLzwy6fuzzhHXw1WSdpMM+5oBXsEX85l5MvIe4NnNARu
0GIk1YvnbwnmXBkceIeUCJhwixQu3ewIbea16ed9DIM4jNykhss5MiBrD7p/n1zd9D6fnQ8noy+n
vavuaHQ+Urm1XZe3zFX5CSqMLzvVDkKr0xZEex3+8/n/jJYKgul1fNwl5AqKwGV3dDkZ9f9xXsMH
zoRe08B0drOJ8+vxbb+gDzZ3RE1B53xToXfZ7V+XrNTo1jUsVpAiqW2k1prAZBeTYMyN4+RtGUPD
tdGjqNYBxxHweFrXdSiBnmNSk6GXtNIsWXhZiTXDgDHH7WHWUYlSPgNryiYZo7XjVZOzGBL8Q02o
IngDAmXpIshkpy5nmrvxvuVVw7Z15w4aX39AOg8i+ONFme+PJP/naZHJV/zuJcU9xh+QqH9q2I6m
Efa/grfDhNjBu9vq4gC7PnHEyRE/Ev3mf2rYONfutuGe4p/vwrYYc7h1tw23h3++E5vbptiCjbj0
8/uwMVDXeVecz/DPd/LWLArAa5zP8OefgK1bwtmK3ft+bMN0dsxBP17QyrWIvhnbNPm2OYjhqlh5
JTzI0P8mbMug9WDjNXX9gjEUa+w3YNt6PpZ/vs8jtmFs2DuR3gK3Epj8JDiUrcLeK5GrZLrlwwrb
YbSlex8YfhDfhq0bq9jwFLxKPwd+STDYfwdvh23FzmG/yyacabm9/wVjyZmumQVvygxblCm2MPP8
mXLGVurOZKt7zEXn/enGmaOVoYNSym+F4brOGtkI3gjjLGF2s2mGEbpejWlaqcLJX+GhwNyjU8LR
RSNMMxtN17XaDFP2KYBUv/ZkozkrMMo+3wCj67rRyKa5U7qzArOdTTOMoevFLF4lsojU21P4gWOf
tEYY3IPcbSHyQRhTN3kjG63RxKZjOo1smmEs3bKa2Aje2ClrmYztZrMHDKa5jbYRWuOA245jNrJp
hnEMJprYaI3OQGe0jbbZB8ZgjSOlNTqD4IzzRjZ7wBi8gY3Ywxlw1y8abLMfjKGJRjaNzkB3NnYj
mz1gjDJs7WbT7AxCZwZvYrMPjGE4jWwanUEYzDQa2ewBY1iNI7WHM5jMahypfWAM22xk0+wMmOA1
jtQ+MIaz3GGVCY46CWkFUXEUv48z2LzaBJYJzrfAmNxsZNPsDA421chmDxhTE01smp1BY5jhNLHZ
B8bUG0eq2Rk0jqlJI5s9YExTa2LT7Aw4QS3WxGYfGNNyGtk0OoOmcdtsZLMHjOls2kZtuIqt46oz
1BQdsTk2+yjqtUHd2WI14WuKmt3c4lbF2inErhZrk7qmaOtaU4tbFTEVaW6xmrg1RY019nG7oqE1
tlibnDVFy2xscbui4zS3KLZQNUXzzNmuqNPM+d5Nu2aq1OxTHPtH4IYhCG6rA2vPTWUKczdNpf+f
K+0a1j4n1zUFh7a+Z3Tl8wae6z3IrTdBXMOVSCzvgqy8IMu263dBCg9DmEPXVbEvW7vhTJwD1c2S
eQTCFLjTXEOzcSNMh84DdQnQAcHoUsJ+PBbMMW1NPFbVZ3AgLNN4hMfyKtKXCIopgf64LEc6As4d
9qhq+6hFfEuHe/Sx5WjCfsRN+v3Dk3yqE9CJwHOQZAs3LNGLS4nQfYsXWWdFuPDBWfD65M4BqDBj
NpvZvKjGo19UlR/KHIDBdHg8XW2tSMzmj0q/ALCXVY+vRbmhAlDXc+sARaR9fnLpijgHsFcArJks
GXDOYbAGUCQcYfzyRCVsBODVakpfZ+WtMgHYyGAdYLmctsm8BYAuRQlAt5BaCYDDsNGF5ZrTpqEq
ALSpputuAaD7nj/1CICGdB1AW6597Uy+lgyq0tEKDfJ5swbg0C1R70Hml0TBDLKHIK1uMuEhjmJ0
fvxYwq9DmGIn5bOk+3q6x8W5FpAUFQXQ5dnNY7vCxtQbsUdXX0478ElGKU7e9ESII7j81Q2D++jE
1I/ghtzihLX4EQyC6Gb6m/Sy9AS/6A2/oPQRXCN0esJLWAdDuI7hpocQ0ySvCvAlTk9YqEqDTNUK
pXPpBbOALuAXKILcQNeZaOsmnMb38aA/HMFBOP8N6TBcDflhDd5kOKiDeBFl7zi1wUVNxaGZiIQ7
0J1l2Py9jGSCrQc+KgSztyOMNnOKLJY9nU1nM5Car6k3y1rV9Td84xNt+Um9ZTpsVy1fceijVZAw
Bhn9MxyYRYg5phqFwyM4K0Leli8rQFudVOeAooSj29h3dczyTv5AHFKBZi9OJNRo2pyvGojiOzlM
umYZa5dldP5By9gqf+9HGcUw7AZSBo+mObgJ/kbX9wskWdQiSL9dV7WN7aqJJGGaZkV5FsRRXqFQ
Vxe0/+3FT3M3g+ez0U1ZhFFUX1BAqotrdD2/9MAfH8LsR7RNfieMa65yq8+VAprSRoWLREqSp0oa
N0SbRi4V0pIpca2Y4bd+TcWie9i85keNTSLRb1XNP2MWeoBZyRqOhvSHbqLciQaqF+Osj0NcmrKH
2E87lSy6ClpqrFzjKxU03h0EPg0Gx2kABk6YwqHhJcgewDRx8X0OqHSHW2aJh4EZbuU9sklryIKs
Atn0deZ6ssUM24KvdKyVTSdh7PqTyH2S6Ry/U7Gvk1cYKSYpDqpH0Wu2CMM3cL1/LoKkbg3TpANR
+fw6k8/o5HRrmmPng7p+c9WBceJGaaBqV3AMVUsU8Grt1MDtwhkYchqcQTd7COPoIHs6RMeDvws4
o8VVDUJVyoexif0MaSbnczI6q2IL7m0ox6ANhC/nHYjijBZcVWIzXxn4dl3HpgKnOFZTtYrl/JiD
DOY06KwmrfaW5L58a0nNdKWkxqnrCkw37S0FO1W0ti2dNsAfj9aa47QNbT1ac8fBJexwBd7+fwm9
drEM/WmhlwDND4Ze0rGLsauH3hX7G+zfG3qpSf3bQi+pWh8Mvbyurk6i8FP+pzifbXM6PMyrAukR
jMqX0vzBBZdqwA4w5eRtx1lO1sMaJdui3fH5dff0qn/9Cfo3LVWJ17/9WxXtbFo0qPpo3B+c33bg
GS0UY1L0qnFV1spPGCA3fiLUr+Kkxel3+jfH0NqY8KkbkVN0IaoQw+AgVApVE3DIE6/Pxx0VbrHD
CT13lcRZ7GF0n7lPAYbLooBYaXBB9xH5skH1q9nbXMLcC3AwSv1KWHADbTXsUcl2r68e1amWGa3N
8odZ3tRzMa+4LdAw4wupwBCRT/QajqCAp3Dy2tHVOlHFgdfFyXQjmWVFTMT4FfkYu1ZrRZcKdI9g
UvS/n8tp+NhijiEw+uv00cTD7W4mJ/jVZKru5Cn6fxqe4ySnyK9dwNcJ/noHNpkgBVW3Sv1xKnx6
DqKGz5luI75acCZVfcWyjQ5cqGeHHPjVfcR93HkxuxncYgaK4ZHaTyndVom5olU1phlakWuEUhkg
X0iPLwIZ+senC8w2kuMhBnT3XlbVHcqSnfa/8bVkjNtazaqtGNhTzo6rDAD3scfCAMU/Bd051tGt
VDfwK/1Y2FD0JoUDw9LU8z7lJlrBWxZfW5DylON46fDH4wepHpaJi9xk+gbyVXoLZcBJ/xpX95VM
R+HalOmcKzE1OnU5nAyUY6joAZPRuFviUYcO5Ct6VoRKFiubrBHmquqzKMem58LmiaQwXUS5uiCd
COaCuWMURb1UTx2QZrKYZ8USer/U09DeywbIJW4xLcAwEfg4I77iB7g6HKhK6bISONdSi1HuzUk8
LWuvKSl4cTF85vXsKxq2mfs/kC0eOypIoIPQlqKFWe4MvNDF+azqJHFsLPRERauCwJzdLhpVKdcc
W0L3muZk8wf8OvTXbLOaVi1KUfP9pS1uc1uUCer/TkankzZ1uT0Z3o7vahC6pX0UYsiG+gaOQdc7
H8O5HI8nGziWzT/M5/yUb+A4lNZ+GEes4RiGRWvLNpyrIHqEr1fXn7s4jWhRAw10+MkAEyz0bMrt
uaDngblRzRXDVHfC7+Kd1vFyuJ924tFtYQNerxnvCPxAPVfrV/HKwKWdNUCffSu0ZZsN0Oeb0Ij8
03YrOAbnDXgXJd5PK4Bb8UxMPZvwPn2An8kcs8mUl1vx6nDwU7XWmtzStAbE4QfmpSk0OjTIn4of
hot79czDkLYrozxZhWfWdixVf9/13Sc4pb1MTV+nxW0e4UZtGA3znSKtujUJg9mbKVU035ZSmY5D
QXgFrlM8aswN3EeprfRS3MLouJxPqumVBhbRliYspunIeNQb9TEfn6Zv+P1TrQy0LmnQCrhIpx6m
z50aX4jkS74A0VYd/AR3owkJzurcLOK2t/bDYlrTtalScJduboZas5Ui5kdiJZVUVqH1EmfExkpJ
FXZWId6fgbtEjmUa/ZjBS5w8HgGlsH/BHPiE1CXul//SBhIPMiqZneOuah5jUusWG5YK3WG0K1KD
SUuY04EgpkNn9dRz7aG5VvF2hhuxBxezEymj1aeMczjMCN6HkxWc3AOOqo13w8lil4dwcpa/3oUT
dC7wbmd51VneyE7T6p31CU65Y4knHIISzvsoOj26s0SR66QIwlE98+JF6KuzlqncCkSpzm4gr+ia
txeYsdI3udXyreI2pRnMMd8D4+UgWuUgvgtI2Skrd3V5ztipsjBeZWEkmF/m92/gJYj8+KWzueSh
VHFrRP83hVJs5lk5K3yjONXFbSU+vD2/OB/3Lt+FNug8ZjtTscLUzIuaG5iaebnjKlO7ZGqvM7UE
35upZYtdTI0VpnZe9dHA1Mkfx19l6hRMpbPO1Mmf49hg6s2KiOFbck0Ht9n2LsZmnTFSttYZK8hV
OE7rGj3V3QH1EPT8CTcHuLHNN+uVD9MxuBuudpcLCuqjlyDzHvJDdbrJVDv9UG258rPZ/HQI6txE
Xqa0YifplnZy1/us1vJ92+F1xfxecsPA5SOqLXyz3phBJxDbEpm6t33FJLv11/zxZQcO1BPDR3R5
qU7+aE2rTm8Q0yRfU4NWHo+EbqYeS8uPXeNZucTVG6GemnodRjMaqIkVapq+nZpVw7QM8VFqYgs1
i3z0YzDGNhgqIPoYjLkNhoJV0/maWCrgPFZXVEOVich3ChI0YdH/nqGoIDCOygqFegWBAtTp8GPc
G4JMCSJIaeY21yQ4ZU0CW4fUmElFIQQ5xVm8J5ZmOLgn38DCQbcUVgculzjp8nyPTlLrvHNc1ax6
W0cyedHRREbxltxZ6FQwfAeDlTPk6hHkeRyGtfsHeo68HmR0TUXelWOk23FrLKmVDtx8riR1jCt3
ZTEFTDE5x2ky/z/iroW3bR1Z/xUCd4FNgNgRn6KMPYt14qQNTtKmcdLTRXFQKLbT+Daxs3606f31
d2ZI2ZJtMbHZxSlQtzY581EUH8OPw+EYXvgU7GfcD3DnyZcSGbmtnLmhDTV/G91N4dl7y+O9x/uM
Z1CD42/Dyb8ex6O835z+uG32B/vLMuokQT3DMZviADV/gAcZjcebVhKQV6CZX8nbu/tP2ZTe6w/u
8vnDbL8kJLE54TYSwxhd46ITDKe+H0joCqXRX8MU/AtGHFCDx2Pz6XT4dfRlwWx9oeHWkaUXMMz0
8qf8dvgwnP0sSRpaUbt4AQMKFwIlmSDi5zJiCwx4mOz+LElabuNHJFCDXls7Fd0tjsNFF5uKzulQ
3HD0NJ/BCD3+AYU9ms9m0Mr3Tk/3oTDs0C8VD71vzyFldp+l18e1XLJXa3o+X/5xdVqGTbWpgT2+
eBGWlxRZwTfDoh6EPSrBgq0I09HVIH8gA4IdE0/fcau/77zJRd4r50ZCDuoRujFMwFDNhxwGk6RY
Lv7tyu9QtBhvZgn7G+7xQNXDMg7nrOl9TqxuYXWVFFtczeE76bXYbPazm+DGBkbBSJ7lHQzW6Dz3
G1P72FtyRqDtpTg8Mi638gmCfXnqkSbT8otGx5FWCYgyUwryRFR4+QQn5sZ09tNHHXuWKRQAbPzU
7h/gli5LkentXl7uHTSbzf1SbVo6xXX6MH56+unqZG+6D2ZRP8Fy86ZSF4vMqczQX/O0c8wS91S4
0m3AQMWhZpN0Ob+n+gVzRtEEWjZn+GabwYUNULapUsXxxU9702GC2/39/Gk26LH22XH66dMndnLW
bR9+PD86RDiiM94etVnn6uzjydUBNJfvLPUjVaGsdOD4H4U2gS4N79jNw2ySw/+copwSJ/+sSJeO
FOfDXmoz0VqK/QGjJTu+z0foQNc+cGrO+r+lBzCVHwot4ZejaUUfzDal73Ts8vIdTJSX3UNROGDg
qP0ZfoU1mWxddsXvB/jlzn25+NO9e5McwIei184PvJcSaU3JTQcWeMMxLAstLMXY70cdau4bREty
PFuVa998qpMrAyqcoB5hCPDP8TieTwfFMIoRVKCTIxuDW9KYrRDVsEJAW8oPLu1rtx3wQLutMDxD
J/02+Hk7xl2+8jjzBDkwiswhlfKQipyUR51F4bQQFhGcZIMcdCa4WO7NYJxQTQ6TRIO+sT0MtNHg
SYOL/QUzNh30YWXz2Ohjm/0XzJ/3+awJT1TSn+GofNJpH7OL4xb7iOph+G7yIkDmIiQmZZcKDY52
/3sO9kPfU5BdmjHa5U1zP9B9LCIcoUawt6/v52Dr/GSSsyTDiVloAmA318feZnAwGtcm7fNuu3gN
GPqmVc5guYsnx6aI3oM6njrOsawmlc6SY735LfptVE0OnydTKybUp9OrCzYazB6QnJ3CuD2YlfJn
SBm9uD29FFAJzhsvCqRliSx7hYQuSUikLZ9wVhqNfzS+2WK7lm/rX1DyHNgTrPc0Z8hmTvfZ3jL8
KlpTfkvNoZN3ZwWdQiDCAI1uVs/oCYwRQi7e/h8M9N/pN1sWxzewKs4X4j1q21XxvCSutVkXFwvx
nO1xGxA3aFGtisuFuADxELrF087dIsLTbf5APQMDZpUykUuD3w29hIH/Hgal3nxGS/NlNmj00k0d
LfYjH5JCHHeQH4f3cguLELDjem4XfcCK/WqVNfFkJy5V/Uh09njyTCPZG+9ldPL89ACvcYL+ojC0
vTQY8fJgJAsQtJtxvsQCMpgdWzA9tthxp3H1/qLsiHZ59v7dyckVY52PLg3/lYlmOAxIdvkBo1K2
33Vh0hUl3WDXoSddPvk6mDnt7Aha/2hEm+Pjx3w4Yh9dlKEi+BYJWo29pSp42u5eN4SfGAU0V3Zx
dDhl3Wu2B0bVCMym8d3dFEZo7pdrqAmpObOqaQ2YTb8NnQcORRdwsWpKOkyyVpqTUT/8DFwbHIUX
FatrKvb85NP1e6hYTMLvnxp/4IZ7FyuW11Qs16mulki/rmJ5aunATEVwt4rNBDermrat2Eyka4/x
YsWKRKeyVLEGK7YznMAs1WiTUyRV7NmRr+dO59/dxrU0mQbzCv90M/O2UrGypNsU3TVptZ3q6/zr
VxiqP8wH85ILWBMUw4L+ngkfR8uJp8RELx/IvO69IEFhVwV/oCmXT3+OevcT9IRfVpwwCQWwqGSn
12jBAjzrnLh3CfZg8TI78DK5aOry6zRy+TplRptkVY3BV6F5U2epwc3v6QSqCetMNh4fe86Wh0WN
eT5UyTPr9Q8nP9hzfogjEkw//X7OwFj9WdJC4aJuRkPMUfQRv0paLpLAuE9KMpYawWQ5aLVns5zo
UmoZXgsUrZAxidQYbmo64RtKK8XzIfx17XTyYqFBGbHuvgA6UAC+lFHWgO0y7S/b7edpP/+TpdzA
46gEXfsbSF0tnV2m5I8HE7c0aaIWZ0BInc7wna2r+4P6GlgBaLnhcmns+V4vZTZKXSBR0B2Mphgq
7paRnyXzwU5JMBW47qyD6zmnUd89Duj01tqPxX6m979kncv3DCbD05v2EsY5pf+ySsqktNtXUiZx
Atq+kmCuwMPa/+1KgiUkjReguoUfHD8Efkj8UIuMglvkqdfLs2isNFL0h9NvSxlYUUPfgnlJNu6m
GEv09D3SAz2M0vnTO5w5J1gs/3gEhuvd8GHgdvCbZT20Din0uCkgd0P0jyEsvG4HC4/a/pzYjgLF
a1FNWNvTJuW3/x3PJ6P8ob+IvAkj8DGs44Yzt4X/HaxfjS1hPOpPS9IKj10uyoB11YLafIIVMus9
DPLR/Kn6IBVZXKcNnmfyi5P44iVa6EjunB7RteEObHlaOg0pBLgC21Dokho6Fb6bGlVSk4pkVzWi
rEauV4gsqoRkpk6hX1F5KfRPWEgtGkNhuC7eF+epzMoAj3iaCaN5L1qIO5BBnD2+eDx6Rme4SirI
n/jjabflDkNhSCmkgvfw6Uua9hfvrSxsk9IZlfmI4iNWThS23KHE5UEVL5fpop8+uWGBaPr7QSGN
h9xANjX2W0ksQ9o1JEbnWKlx4bO2WAbgTl4jU2GRJvw+zBsT3C5o9lrIJCaN8995UzUlLaUbiWwk
hkBmgxESdJ0x9YWjASxkJ0tllmKDBMmvtEp+ic3kV7bQaQUN+4PZPYwdH8/a7Ip2Nc7OvDf1ICeX
EQy53dJJ6zZv3YlWLlu8f+BVNZe6pJALXReg4vLtv71TESgrwiXbA+zjM3TyfE6tyCAB2tpsSEut
hA+487BSesAXqrUUVr+wV8hlU37uLB9dbnz0wsggnRluKQ/ue8Mv971+RRFYR28B5S063Cw5sqWo
VGgJ1oii79BN94gWgUv+4sCT90jBQsJo/ngLlggv6TTonl6jsz+4nX91zNhSRCs6D1EjQoGk4c0N
x9gx6GXe0iHYkrwmj/LN8vgIuBHh97AOXJXAugV0evONJ2Am97ARq6VSnXBJTlX4l7dWvOz/h7Pe
/XgK7fxuMn5k9K0g6Jw4R8+7+/kt4w0oSjNxJcEfqC2Vcgo0LCs5rePYobpcFN1F5izhmocsyuJ0
z/Rr4jzbdEmW9rjqjcGlLF+XlWplhq6TFU528XqMkgY5NcfY5V+fvsJ7KDm0fU/wkILLbcBo4MJC
dYy+D/vDHAdm3IxjD1C3YM6wv7/7eNY5a/8dlgCgYeoHr2YhbY1OpAh1MLcjVxpbuNncwXhJp8Lx
4N3Hq4sWw6N12MNdOfxDPVtThL2+cOXF9tXIjMwY/DJi7acJAomkJXAbg112Sjf+6LSJ9xhY+cKY
qKtjYrK53KLQKROr0bJp96nAMEhk1n5j0x852RJIwxyiKQYWyuVkOIZR+2erwXHqHkDNtjjYQJPx
dNrygoXazAiK5YVTJzvtoiqcnQ/cG4XxnnkbyAnYJhp3SN48PEGjcYfaim0ZtrfYAWxQVxx5KtaI
poUpGnv1DiaVk6ZgCdVSippSOgEygHa1CFCFSixW+I4lVs6ar5ZYBUqsMoW2wM4lVrTVTsbj7B4G
OCKd508HMBwmF7foqInnQxv9OdhOz9DKnnIYfJU+cT3D6CZMH+QAvb24TSRRVgkODI7HgJX14PnJ
xQyHiQXNHvbjHh6FDfsPg7IMRq7snnxodzpX7Lff0GfPUrLJmmBEunVZdXwcPD45c2fM/jMfzDFS
O2sfvb+6hhllOs2/DsryaJscd44wTECy6W85L+4N+uK3Z7QPjtvghd2J5wcnffYjn5L74FPubyda
iOMp23+u/WGd+eMTO0bR7gy3uombmbJ/rP6pqEoXJUFxOme61LCsyAO0YYraW606QwdRfZHXi5vS
LvTxzQXDWs8PWPfsXefkE31TYA91ll8H0HDbV2++CPomKlrg/bw9fndNKcjnHV1eX9GX23I2ZABx
1Xf5tt09wdsv3Nfu2Zsz9+3k6ur9lftvSU4h2YAZj2665y71vN29LrRwr+XkA37Jq6LYGLtH578f
X6Nk7rJeta8L+JMPLoWvQJKD+MmHL6fn7Tfdz+jdCt+71+3rxAvi//l6UZFmoTRRyif9/88u3ndO
UIGtCqGt5xJRY4619On0CgpGeTHy/ilU7tX5GhydKOmcIsYNltJm1WQkwSHx+Pei5XOj8DPN6LOc
lXrg8RG6xo5m8OpoAbhIVctLIN7B4PQBc/7m9j2XebRvaeUcFQw8j/8BFvV4TdIy8EzKuK2UGnmD
P/yOxQfq28vMvAWGXTkzknGd4RTG3ZEbaFYkynlxl+/D+5vragEqOfBNDGBAgXXshJZyVCnnuF8I
a1XOuMRtTDxRkVDJ4TNjCoy7lAlnDuDT4CkLzTLc4Yd1Dtj7QjHcnIR0yGfRkVEmuG9Zwja4eF1i
I+wZBdKv5KEteOphX47fQ5t4j41iQB3p6Au27bMO/ECtEH44v3m31mZSdKLAxOv2G7xz5m4llZxv
eRSCDiK4CIciCsGNJHUILsCfjEGw3AQQrIuUr6IQsL/UI7hwkjoKIQ0iWHKgNjEIWRJ6DxknhDQK
QQYRXHBoG4VggggucG8WhZAFEKS7V47H9GlJ5Es9AoVL4qt9Wq0iqBCCriDk1URDACLqEawOPQLd
HcJjurTkPFRJXBCCikIIdWnJNSHoKIQ0iEBuLDymS0uRBAY+SR58OPHFIMjQM9DqA+fQGAQTfAYK
asuzKIQshCApFLWI6tKSBxHoRJFY7dKrACi1BFjVgVFU6hEoMKYQUQhpEIGOOQkZg6CSNICgOCGo
KAQZRKCYnEJHIVDAuFoE7PFoOUYg6IQHEFyocpFGIcgggiQEG4WAC9l6BLoiRWRRCJkMIZBfkExi
EIwIjXwG6xAXBTEIOjRqGDR1LgfOuYJ8IKup2aaRd81M0IFRy9BJuLX5wWwz8jl/kDWDaCtzJcVD
N37BuljFuSfG1ZjAtZzEmZLToXhYnYGJZ8HcFni/KE4OCVj3KaMFXVkvGs03o5n3zNlT+xitqprD
VnJozGErOXDuqHyHsq4RQWuM0cmoP93ALJUUWdykcYRR4U732Gf5rXOupz0Nv/ouC+ERaPTmfn5+
/kJ52WQwm09GuAmG9+5S3hTyWk1RzXbi4Qp5+woezufVejcezoubX8DDFapUDA9XKDGbeTifnIoo
Hq7QYsI8XJEt25KH83LORN+Oh/Oi2Mq24uEKuWxLHs7JabJiX83DeSE0brfk4QrJbDMP55PRYesl
Hs5nlWIjD1ekyo08XFLJY2p5uCJHWsvDwSKunFPVU3GVbOoVJFyRN60l4YocNkDCwXD93+LhPDxu
wNTycEWeNIKHczpMstkYKFJNBA/ndfAggrsxQkQhiCCCOxIuoxBkEMHdeKaiEJQKIbjbqHQUgg4i
aBPBw3kdJohgTAQP53WkQYTURPBwXocNIlgdwcN5HVkQAfv9zjyc05EmIYQ00Zt4uNfZtV4FDwLQ
oQce1aXrtgeKVB3Bw3kdMohAF2nyqC6dqiACXfjEo7p03RZHkaojeDivwwQR6H4nHtWl0zSIQLwD
j+rSFBuiHoG6NI/q0mkWRKAuLaK6tE1CCJa69K48nNfBgwg8hofzOoJ92tINKLvycF5HsE9bug5m
Vx7O6wj2aatUBA/ndWgRQnB8qIlCMEEEuvtmVx7O6wj2aUsXAe3Kw3kdNvgMdMhrVx7O68iCCHTR
z648nNNBAUJrEWhTc2cezuvgQQS+mYcrUs2mWVxtYydkbjdrRy6v0KEiuLxCR/aLeTivV23g4UQ1
h6zl4Yoc+s+173E8nFek1TY8XCGUvpqHo6gpG0/WbMPGUUg0z8aJfIWK6xkkjdLSL1B5VYYuS9MY
ho4uof01DF1mdTxDRx739Qxd5gJRRzJ0dNftywxdlu3E0Jkk2ZWhMwnfiaEzdFPH9gydSYg62I6h
M+QIvgtDZ+iy2FqGziQ0Mr6GoTN00WsdQ+eOx25g6KoaNnnKJZUcZhNDl1RHMEN+Fy/Sc5BNvJae
M3RxbIiegxzmL6TnDCdrOUjPGe6uWIyx+w0P2cyQqmLpOcNlEMFdoSiiEJQIIZDNHEXPGa6DCO5y
TRWFYIIILv6qjkJIgwju8kwThWCDCC7caxqFkAUR3LWqMWt5I2p8CIpUGUvPGRGymSFVxtJzRojg
M5BPTQw9Z4QMAkgZS88Zco+qRyB3lCh6zggdRNAylp4zwgQRqEtH0XNGpEGEVMbSc0bYIIIVsfSc
EVkQIROx9JyRwS7tnNii6DkjeRCBi1h6zkiRhBDITzuKnjMy2Kcl3XQeRc8ZqYLPoEQsPWekDiJQ
SJcoes5IE0Sg6NtR9JyRaRCBnDqj6DkjbRCB+nQUPWdkFkSgPh1FzxmK9l+LoJxjahaFwIMI1Kej
6Dmjgn2a7muOo+cMhZirR6ALNGroOUiVsdSaIafSdWNmG2rNKLQENlNrXESxa0ahCRDiziCHrBYG
Lf1fwJ0ZRUFjPHdmXsedGaJLXuTObIZxKsi7JII7c1roNoUXPdl8Xm1348m8ODaCWJ6sUGVjeDKv
BMfhTTxZkWyieDKvBYfiEE9WZBNb8mSFXLY9T+ZFs21PlDq5lPYRt+HJCrlsG57MC+3Ak3lJ7Mib
eDKfTKvxF3gyn9Vv/q7yZEWqDXiy+Ty4bK3xZCtypOETpS6b5S/wZEU2+wqezOcV9TyZz0Hv4C/g
yRx8hqF1a3kyn0fF8GReR41ZVqTGuLGRjiypWaYUqWkET+Z1SBFCkDaCJ/M6arw5itQsgifzOmqc
m1wqd7fl6BgEXuPs51Pp9MKuPJnXUXN6waeaGJ7M67A2hEB7y7vyZE4HXeRbiyBEjBub16GTEII2
ETyZ12GDCNbszpM5FXW8QJFqIngyr0OFHoHu/9uZJ/M60iACDXw8qkvXreWKVBPBk3kdMoggY9zY
vA4d6nB0tGJnnszrCHZpiga+M0/mdGgeQtDOTSKqS9MdJPUIdMpdRHVpbULTg06TCJ7M6whOQIYm
oF15Mq9DBBFoAtqVJ/M6dBCBLsfblSfzOmxoEjUUuWJXnszpqHMR9qnkGLQrT+Z1qNAzpBS5Ylee
zOtIQ4ZAamN4MqfD1hwc9qk8xo3N65AhQ8DSuYJdeTKvIw3Nohbdc3bmyZyOOkc5n4rLqg08WZG6
0YHYbDNqUfSP9fnhlVyb14HeFr+aJ0PVNqFokqs8WVrJgTuOle8ilifziqTehidzQhydO17Fk2He
bC2u5OsZMpBPX8uQQV5rdmfIQDyTv4YhQ1UqliFDJaaeIbOJSEQ0Q4Za9MsMGWazOzBkIMfVbgwZ
iNIu+7YMGcrZHRgykKMQQVsxZNbd8r4DQ4aStp4hg2SdvI4hg6yG1zJkmBryJCvyqFpPsiJHjSdZ
JU/2Mj0G2bBHv4oew7wqSI9hDvPX0WM2oZCQQXoM8+hIegx0yHprDFN1JD0GOlQQgQ47xdBjoEMH
EeiwUww9Zt012vUIdNgphh4DHWkQgQ47xdBjoMMGEdz5RROFkAXfAx12iqHHbKKSEIKiw04x9Bjo
4EEEdyY5i0IQQQQRS4+BjmCfVjKSHgMVwS6tVCw9BjqCXVo5DjGqSysTRDCx9BjoSIMIaSw9Bjps
EMHxoFFdWgW7tMpMJD1mEx3s0tqRiFFdWnMdQnBkblSX1sEuTbc7RtFjoCPYpSmkRhQ9BjqCfdrd
FRdDj4GOYJ+mew2j6DHQEezTdMdVFD0GOtJgW6I+HUOPgQ4bRKA+HUOPgY4siJClkfSYTepChxSp
aSQ9BjqCfdrwNJIeAx0iiCDSSHoMdMgggoylx0CHCiLgFF9Dj2Fq9qooZzowahkta6ktG81uUVCR
VXZrJYeplsf8f3HnslvHDQTRX/En8DF8LbMQsne8DQID1taLBMj3R2xWTySb7DvDsqCl0M0qCbqc
x7nN7vJr6JZ0G1G6lS7SLWkg8pButQ4FQx7z+Dbo1lgvI/ge0i3klrZHt7C8/oL6L5VqDN2CSP+O
Yka3NFwoujVUqntQ/6Vp8Sbdwjrv7tMtXVpu0i2sk2eYO3QL66T8/DLdwiJ5FLhHt7Cy32JndAth
eSJ+QLdGanPziQKIemfUf2nOupMZMvq3WbP6r9c58UHxl6aVC3QLuce6+AsZcojmA+iW2EeXLbql
OY2gW9BYvL6MKIqOPOPgQ7Yc5PTFLt2CRiqWwyg6ipRDbZZDY+jW0AiLinmNMj3MoJFMB6qHGTSq
6VCZHmZDY1V1pNFC0C1oLA7carQSdAsaC46p0UrQraGxYoCIerdPtyCxeC5HdPR/p7b0kU2H4gm6
BY1mOUi/7W26BY1gOkixi6e2dErWpVWm8GzTLWhU06ExhySHhryJLh1yiATdgsaiSz6iY6YDtaVz
tm4PuTA9zIZGcdaFrwxesPkmDI1oXZZKL4XZplvQMPd0KUzxFzSa9WmtjjkkCY1gfZbQJS1RDsl0
yEwPM2hU06ExPcyGRjP3dBuTLyrlcJgOcsR9l25Bo5gO0vFhl26JxuGc4XBIZdI23YJGzJbDMe9h
ptFGFG5BI7d3oVtD3Ye6rN1CRn8jfPNzZekWhPpN4zrdwqJLtVvIFXz2qE//py+/ff796cunz09/
PE0Y14tKu8q4jtBf9V479tmoX79/E6Sls5H/T371p3x7/vevv5//eZ79Od695OdUqt8bO3CuvzB2
ALlSF7oB63R5LxUnYZ1KhUDAulNk3tRMw5E6rKkqveuIAevOtJtNzXRd8bdhnS6V9rA3YB3WSYPG
O7BO18U7Tc10Ubo9/lNXlnkpmobl8duGdSM1u1Em+COs06g3StHOnLIqRdOMzsxXpWiaE+2BA2fa
hZOamtu/Wp3DOs1IH3NSE/Y+lzWs0xxpb7EJ61Rj/nyLKDo4ecYhhGI5SOOETVinGvPnW41moqOZ
asxhnUYZWAeN6C2HyMA61ZjDujNKwDrVmLc/OqNlH9ZB45h3xT6jbR/Wqca8IkOj8ma/CetUY17N
oNFKDP6ERnKWQ/J+G9apRLQuGkl6E3lqS8votrVDITqaqUazHLK0e/bUls7BdBinWKgtnc0LXx7n
KKktnc0LH6ZjUFu6mBc+jJagtnQxL3wlEaVoqlFMh0J0NFONZt1E5RvvXVinGuanFRgqUA7mpxUY
KlIO5qe1jsEPB+PQgvWfboEoRVONZN1E5bVgF9apxrzx6Bmt+7BuaBRn3aZfonUf1qmGdZsuTm7T
m7BONazbdHEyVHkT1kHDO+MuWrwnBn+qRjQdesHCz7DujLb9gZuqUdx7wDqoh/49/3zspmYcb38f
Od9FwToV6jT4cjN/XXQF1mluf8J5WIq2hHWnymXGVUJ/HnrtOIV1SJY2oJdgnX/JT1WmZ+xU1ul6
f6GyTnPDXmWdLu+fERbWqRQzgUBF0ryy7gw3CtZBpT97WLAOaeVmZzVd1+6fGx1Lm5Oa4zuwDuvk
0ncH1mFdujMjVBeV+7AOK9sC1o3wuEU8gHVIBWb5EdYhGsO6su7MKavKOs04/LqyTnPSA1inaVdg
HXLzGtYho3wQrBv2oRrjB86cSsC6oRHn5+Q0GojKOtU4TAfp4rEL66CxeK5CVJ6rdmHd0DgWz1WI
Si/aXVgHjVgsh9FAL1EO8/IPjRbi3Cg00ryP1BllYB005g30zmglYB00sumQico61ZiPEjyjjYB1
Q2Nx5EWjkYB1kEjWdsiZgXXQqNZ2yI2BdUNjBYkQDcR0UNVI1nYAJKK2dKmmA3NuFBp1Xsp6RisB
66BxWNuhjldGaksvZhWe0UbAOmiYW7qOk3jUlm7BcpD3k21YB41k3aZlEtw2rINGNR0aUVknGtk5
v74u5dETaRvWQeMolsOo6EqUQ6mWg7R32IV1Q8N7Zzh4OUe9C+ugcXjL4SDOjapGCZaDlKfvwrqh
EVw0HIKUp+/COmjEw3KQZozRUw45WQ5lWll3Rut+ZR00onsfWAf1zinmlXWakevb36c/AnOwDkLV
36isw6IjhQuwDrk3Jm+ukZ1qpb35m7q+13P8/LvMYd5YIgcTLsG80C/+wfXHjP1hCadKvoD0kBvD
HtLD8v6FNIv0VCozSA8iK6SnYQ7pQSXbQ0U17TbSw7odpDeWyiDGW0gP624jPay7h/SwSDqR3UN6
WNmfIGdIb4SDe3xYVlPD9LCsRqM36u80Jy/r75BxOKP+DjnJPix7pl04LKu5edkKTjPkO/UPQHrD
ftQyrZCe5hCt4KCxGJx0RolWcKpxmA7SY2YX6UGjmA5j2kNkHNL8rNIZLQTSg0Y0HaQvyC7Sg8YC
Vmm0EkgPGs38GxqD9IZGDtbfIAVP20gPGilaDqkRSA8a1XSoDNIbGotm22e07SM9SBymwTh+SG3p
sqD0iFbisCw0qrMcqicOy6pGNB3klc1TW7pm06EQh2VVo1kObRwpprZ0m/dS0GgkJoqqRjIdMjFR
VDUWABpRAdCB2dJRj0JMHaIbneE3X/+hEU2Hg6m/g0YuloPU1O4iPWg04z8dPXNYVjVCshwiMSlB
NZLpkImJoqpRTYdGTEqARrBuQFFacW8jPWgcpgNVfweNYjpUBukNjeiMB4GXaCOQHjRisByO6aSE
M3rsTwNVjZzeBekN9SPEP9/+zI77VKFbYwx0UW/JYAK7/wDr2x5G8hkBAA==
------=_Part_50952_1198914.1184465090554--
