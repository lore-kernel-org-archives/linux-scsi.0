From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.4+ merge window
Date: Thu, 31 May 2012 20:47:17 -0700
Message-ID: <CBED88EA.47E61%giridhar.malavali@qlogic.com>
References: <1338494279.30470.461.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338494279.30470.461.camel@haakon2.linux-iscsi.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Avik Shau <avik.shau@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Nicholas and all others,

I would like to thank you very much on behalf of QLogic Linux FC/FCoE team
to everyone who worked with us to get QLogic >= 24xx initial target driver
upstream for 3.5-rc1. You responded quickly to our queries and provided
the support to get this functionality delivered on time. We would like to
work further to get other target related functionalities upstream in
future. 

Thanks,
Giridhar


On 5/31/12 12:57 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>On Thu, 2012-05-31 at 13:17 +0100, James Bottomley wrote:
>> This is primarily another round of driver updates (bnx2fc, qla2xxx,
>> qla4xxx) including the target mode driver for qla2xxx.
>
>Hi everyone,
>
>With the Qlogic >= 24xx series HW target driver code now upstream for
>3.5-rc1, I wanted to take this brief moment to thank those who have
>contributed to reaching this initial milestone:
>
>Andrew Vasquez (Qlogic)
>Arun Easi (Qlogic)
>Chad Dupuis (Qlogic)
>Giridhar Malavali (Qlogic)
>Joern Engel (Pure)
>John 'Coz' Colgrove (Pure)
>Marco Sanvido (Pure)
>Patrick Lee (Pure)
>Roland Dreier (Pure)
>Scott Dietzen (Pure)
>Steve Hodgson (Pure)
>Jerome Martin (RisingTide)
>Madhu Iyengar (RisingTide)
>Marc Fleischmann (RisingTide)
>Christoph Hellwig (LSF / RTS)
>Andy Grover (RHAT)
>Dan Carpenter (Oracle)
>Hannes Reinecke (Suse.de)
>James Bottomley (Parallels)
>Stephen Rothwell (IBM)
>Vladislav Bolkhovitin (SCST / ID7)
>
>Without the help and support of these people the initial merge for
>v3.5-rc1 would not have been possible.
>
>Thank you!
>
>--nab
>
>
