From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.0+ merge window
Date: Mon, 11 Mar 2019 14:51:20 -0400
Message-ID: <yq1ef7dqm6v.fsf@oracle.com>
References: <1551940186.8289.60.camel@HansenPartnership.com>
        <CA+8MBb+MJhS9ejWQ0+vjDyhdnK5bsuaLPwpM5f-h1-6tHr4rVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+8MBb+MJhS9ejWQ0+vjDyhdnK5bsuaLPwpM5f-h1-6tHr4rVg@mail.gmail.com>
        (Tony Luck's message of "Mon, 11 Mar 2019 11:47:41 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Luck <tony.luck@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


Tony,

> arch/ia64/hp/sim/simscsi.c: In function 'simscsi_interrupt':
> arch/ia64/hp/sim/simscsi.c:108:51: error: 'struct scsi_cmnd' has no
> member named 'serial_number'

I asked Hannes to fix this but he's been quiet for a few days. I guess
I'll clean it up...

-- 
Martin K. Petersen	Oracle Linux Engineering
