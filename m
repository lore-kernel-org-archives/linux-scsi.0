From: Andries.Brouwer@cwi.nl
Subject: Re: [patch] NCR5380.c fix
Date: Fri, 16 May 2003 01:10:01 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <UTC200305152310.h4FNA1X19100.aeb@smtp.cwi.nl>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

> any reason not to use the newly minted SAM_STAT_GOOD and
> SAM_STAT_CHECK_CONDITION?

(i) this brings NCR5380.c a tiny little bit closer to sun3_NCR5380.c
(ii) I am not so happy with SAM_STAT_GOOD etc.

Maybe it is just me, but I do not immediately think of SCSI given SAM.
We have sym_defs.h with

#define S_GOOD          (0x00)
#define S_CHECK_COND    (0x02)
...

and aiclib.h with

#define SCSI_STATUS_OK                  0x00
#define SCSI_STATUS_CHECK_COND          0x02
...

and scsi.h with

#define SAM_STAT_GOOD            0x00
#define SAM_STAT_CHECK_CONDITION 0x02
...

I wouldn't mind merging these three and choosing the SCSI_STATUS_ prefix.

Andries
