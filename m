From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Thu, 7 Feb 2008 12:37:22 -0800 (PST)
Message-ID: <393719.81864.qm@web31808.mail.mud.yahoo.com>
References: <1202398695.1805.48.camel@haakon2.linux-iscsi.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:38994 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756191AbYBGUh0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 15:37:26 -0500
In-Reply-To: <1202398695.1805.48.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ming Zhang <blackmagic02881@gmail.com>

Is there an open iSCSI Target implementation which does NOT
issue commands to sub-target devices via the SCSI mid-layer, but
bypasses it completely?

   Luben

