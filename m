From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.4+ merge
 window
Date: Thu, 31 May 2012 12:57:59 -0700
Message-ID: <1338494279.30470.461.camel@haakon2.linux-iscsi.org>
References: <1338466675.3073.21.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52458 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab2EaT6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2012 15:58:03 -0400
In-Reply-To: <1338466675.3073.21.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>

On Thu, 2012-05-31 at 13:17 +0100, James Bottomley wrote:
> This is primarily another round of driver updates (bnx2fc, qla2xxx,
> qla4xxx) including the target mode driver for qla2xxx.

Hi everyone,

With the Qlogic >= 24xx series HW target driver code now upstream for
3.5-rc1, I wanted to take this brief moment to thank those who have
contributed to reaching this initial milestone:

Andrew Vasquez (Qlogic)
Arun Easi (Qlogic)
Chad Dupuis (Qlogic)
Giridhar Malavali (Qlogic)
Joern Engel (Pure)
John 'Coz' Colgrove (Pure)
Marco Sanvido (Pure)
Patrick Lee (Pure)
Roland Dreier (Pure)
Scott Dietzen (Pure)
Steve Hodgson (Pure)
Jerome Martin (RisingTide)
Madhu Iyengar (RisingTide)
Marc Fleischmann (RisingTide)
Christoph Hellwig (LSF / RTS)
Andy Grover (RHAT)
Dan Carpenter (Oracle)
Hannes Reinecke (Suse.de)
James Bottomley (Parallels)
Stephen Rothwell (IBM)
Vladislav Bolkhovitin (SCST / ID7)

Without the help and support of these people the initial merge for
v3.5-rc1 would not have been possible.

Thank you!

--nab

