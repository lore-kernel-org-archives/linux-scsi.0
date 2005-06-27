From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Mon, 27 Jun 2005 09:22:22 -0500
Message-ID: <1119882142.5175.11.camel@mulgrave>
References: <20050626153941.456543d6.akpm@osdl.org>
	 <1119829031.5038.15.camel@mulgrave>  <20050627044647.GA4104@nikolas.hn.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3545 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262051AbVF0OWd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 10:22:33 -0400
In-Reply-To: <20050627044647.GA4104@nikolas.hn.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Orlov <bugfixer@list.ru>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Mon, 2005-06-27 at 00:46 -0400, Nick Orlov wrote:
> c0267437 tw_interrupt+0x317/0x480
> c013ac9d handle_IRQ_event+0x3d/0x70
> c013adb0 __do_IRQ+0xe0/0x170
> c0104fc3 do_IRQ+0x23/0x40
> c01031ce common_interrupt+0x1a/0x20
> c0100ca6 default_idle+0x26/0x30
> c0110bbc apm_cpu_idle+0xce/0x160
> c0100d24 cpu_idle+0x34/0x50
> c03947e5 start_kernel+0x165/0x180
> c0394360 unknown_bootoption+0x0/0x1e0

tw_interrupt wasn't actually modified.  However, it should have executed
another call, probably where it's doing a null ptr deref, probably in
one of the completion routines, which should be identified by the EIP;
could you tell me what this is?

Thanks,

James


