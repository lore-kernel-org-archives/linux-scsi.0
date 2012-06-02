From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.4+ merge
 window
Date: Fri, 01 Jun 2012 17:16:02 -0700
Message-ID: <1338596162.23917.108.camel@haakon2.linux-iscsi.org>
References: <CBED88EA.47E61%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CBED88EA.47E61%giridhar.malavali@qlogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Avik Shau <avik.shau@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-05-31 at 20:47 -0700, Giridhar Malavali wrote:
> Nicholas and all others,
> 
> I would like to thank you very much on behalf of QLogic Linux FC/FCoE team
> to everyone who worked with us to get QLogic >= 24xx initial target driver
> upstream for 3.5-rc1. You responded quickly to our queries and provided
> the support to get this functionality delivered on time. We would like to
> work further to get other target related functionalities upstream in
> future. 
> 

Hi Giridhar!

I'm really happy to hear that Qlogic would like to expand it's upstream
target-mode support offerings based on the positive results from qla2xxx
with the target-mode development community thus far.

While it's going to be a busy ~8 weeks until 3.5 is released to resolve
the outstanding active I/O target shutdown issues with tcm_qla2xxx, I'm
eager to get these remaining issues get addressed for this first round.
 
I'm also really excited to see 83xx target mode support included as a
for-3.6 -> for-3.7 item..

:)

Thank you!

--nab

> Thanks,
> Giridhar
> 
> 
> On 5/31/12 12:57 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> >On Thu, 2012-05-31 at 13:17 +0100, James Bottomley wrote:
> >> This is primarily another round of driver updates (bnx2fc, qla2xxx,
> >> qla4xxx) including the target mode driver for qla2xxx.
> >
> >Hi everyone,
> >
> >With the Qlogic >= 24xx series HW target driver code now upstream for
> >3.5-rc1, I wanted to take this brief moment to thank those who have
> >contributed to reaching this initial milestone:
> >
> >Andrew Vasquez (Qlogic)
> >Arun Easi (Qlogic)
> >Chad Dupuis (Qlogic)
> >Giridhar Malavali (Qlogic)
> >Joern Engel (Pure)
> >John 'Coz' Colgrove (Pure)
> >Marco Sanvido (Pure)
> >Patrick Lee (Pure)
> >Roland Dreier (Pure)
> >Scott Dietzen (Pure)
> >Steve Hodgson (Pure)
> >Jerome Martin (RisingTide)
> >Madhu Iyengar (RisingTide)
> >Marc Fleischmann (RisingTide)
> >Christoph Hellwig (LSF / RTS)
> >Andy Grover (RHAT)
> >Dan Carpenter (Oracle)
> >Hannes Reinecke (Suse.de)
> >James Bottomley (Parallels)
> >Stephen Rothwell (IBM)
> >Vladislav Bolkhovitin (SCST / ID7)
> >
> >Without the help and support of these people the initial merge for
> >v3.5-rc1 would not have been possible.
> >
> >Thank you!
> >
> >--nab
> >
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
