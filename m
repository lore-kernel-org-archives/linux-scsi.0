From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.29-rc4: Reported regressions from 2.6.28
Date: Sun, 8 Feb 2009 13:55:44 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0902081354150.3048@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
Sender: netdev-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Natalie Protasevich <protasnb@gmail.com>, Kernel Testers List <kernel-testers@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12669
> Subject		: 2.6.28.4 regression: mmap fails if mlockall used
> Submitter	: Sami Farin <safari-kernel@safari.iki.fi>
> Date		: 2009-02-08 10:52 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=123409037423068&w=4

Oh, Hugh just sent a patch, and it's now commit 
d5b562330ec766292a3ac54ae5e0673610bd5b3d. Sadly this just missed -rc4 by 
something like 20 minutes..

		Linus
