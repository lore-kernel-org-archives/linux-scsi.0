From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Wed, 7 May 2003 14:20:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507142057.760f426b.rddunlap@osdl.org>
References: <3EB11AD3.2070503@torque.net>
	<3EB22F09.7060906@torque.net>
	<20030502095536.76dba4dd.rddunlap@osdl.org>
	<3EB385F3.6010708@torque.net>
	<20030505095715.6d96e703.rddunlap@osdl.org>
	<3EB7748F.2030702@torque.net>
	<20030506073923.210a82ff.rddunlap@osdl.org>
	<3EB90867.6050803@torque.net>
	<20030507111634.2cb1fe95.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:4995 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264262AbTEGVLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2003 17:11:30 -0400
In-Reply-To: <20030507111634.2cb1fe95.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

| Hi Doug-

| On Wed, 07 May 2003 23:21:43 +1000 Douglas Gilbert <dougg@torque.net> wrote:
| 
| | Randy.Dunlap wrote:
| | > On Tue, 06 May 2003 18:38:39 +1000 Douglas Gilbert <dougg@torque.net> wrote:
| | > 
| | > | > Are there any docs on SCSI logging?
| | 
| | Do your failures only occur in an SMP environment?
| 
| I'll try 2.5.69 plus your patch ver. 2.

2.5.69 + your ide-scsi ver. 2 patch, booted with "nosmp":

  hangs/locks up during boot sequence, immediately after this:

end_request: I/O error, dev hdc, sector 0
scsi0 : SCSI host adapter emulation for IDE ATAPI devices
ide-scsi: hdd: que 1, cmd = [ 12 0 0 0 24 0 ]
ide-scsi: abort called for cmd serial #1
ide-scsi: abort ignored
ide-scsi: reset called for 1
ide-scsi: device reset partially ignored
ide-scsi: hdd: que 1, cmd = [ 0 0 0 0 0 0 ]
ide-scsi: abort called for cmd serial #1
ide-scsi: abort ignored
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0


same kernel without "nosmp", so it's dual-proc P4:

  I ran cdrecord, got to an error, cdrecord had a segfault.

Not much help I'm sorry to say.

Complete logs are here:
  http://www.xenotime.net/linux/capt-2569-nosmp-locked.txt
and
  http://www.xenotime.net/linux/capt-2569-isc-dual-segv.txt

--
~Randy
