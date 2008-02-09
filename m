From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 8 Feb 2008 23:32:55 -0800 (PST)
Message-ID: <462600.51623.qm@web31810.mail.mud.yahoo.com>
References: <47AC2FA7.7020700@vlnb.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:20878 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751824AbYBIHc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 02:32:56 -0500
In-Reply-To: <47AC2FA7.7020700@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ming Zhang <blackmagic02881@gmail.com>

--- On Fri, 2/8/08, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> > Is there an open iSCSI Target implementation which
> does NOT
> > issue commands to sub-target devices via the SCSI
> mid-layer, but
> > bypasses it completely?
> 
> What do you mean? To call directly low level backstorage
> SCSI drivers 
> queuecommand() routine? What are advantages of it?

Yes, that's what I meant.  Just curious.

Thanks,
   Luben

