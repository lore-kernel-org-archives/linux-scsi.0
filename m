From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Wed, 7 May 2003 11:16:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507111634.2cb1fe95.rddunlap@osdl.org>
References: <3EB11AD3.2070503@torque.net>
	<3EB22F09.7060906@torque.net>
	<20030502095536.76dba4dd.rddunlap@osdl.org>
	<3EB385F3.6010708@torque.net>
	<20030505095715.6d96e703.rddunlap@osdl.org>
	<3EB7748F.2030702@torque.net>
	<20030506073923.210a82ff.rddunlap@osdl.org>
	<3EB90867.6050803@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:56195 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264153AbTEGSHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2003 14:07:07 -0400
In-Reply-To: <3EB90867.6050803@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

Hi Doug-

On Wed, 07 May 2003 23:21:43 +1000 Douglas Gilbert <dougg@torque.net> wrote:

| Randy.Dunlap wrote:
| > On Tue, 06 May 2003 18:38:39 +1000 Douglas Gilbert <dougg@torque.net> wrote:
| > 
| > | > Are there any docs on SCSI logging?
| 
| Do your failures only occur in an SMP environment?

Yes, I've been testing only SMP.
I just rebooted 2.5.68 + your first ide-scsi patch with "nosmp"
and it faults during the boot sequence at
EIP is at scsi_eh_offline_sdevs+0x21/0x78.
Full log available if wanted.

I'll try 2.5.69 plus your patch ver. 2.

| and the pattern continues with the two atapi devices changing
| positions. So much for device naming stability.

8:(

--
~Randy
