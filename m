From: Nick Orlov <bugfixer@list.ru>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Mon, 27 Jun 2005 22:08:58 -0400
Message-ID: <20050628020858.GA4111@nikolas.hn.org>
References: <20050626153941.456543d6.akpm@osdl.org>
 <1119829031.5038.15.camel@mulgrave> <20050627044647.GA4104@nikolas.hn.org>
 <1119882142.5175.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta9.srv.hcvlny.cv.net ([167.206.4.204]:47968 "EHLO
	mta9.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S261424AbVF1CJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 22:09:22 -0400
Received: from nikolas.hn.org (ool-45731e9d.dyn.optonline.net [69.115.30.157])
 by mta9.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-2.06 (built May 11 2005))
 with ESMTP id <0IIR0068LV9N0RL0@mta9.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Mon, 27 Jun 2005 22:08:11 -0400 (EDT)
In-reply-to: <1119882142.5175.11.camel@mulgrave>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Mon, Jun 27, 2005 at 09:22:22AM -0500, James Bottomley wrote:
> On Mon, 2005-06-27 at 00:46 -0400, Nick Orlov wrote:
> > c0267437 tw_interrupt+0x317/0x480
> > c013ac9d handle_IRQ_event+0x3d/0x70
> > c013adb0 __do_IRQ+0xe0/0x170
> > c0104fc3 do_IRQ+0x23/0x40
> > c01031ce common_interrupt+0x1a/0x20
> > c0100ca6 default_idle+0x26/0x30
> > c0110bbc apm_cpu_idle+0xce/0x160
> > c0100d24 cpu_idle+0x34/0x50
> > c03947e5 start_kernel+0x165/0x180
> > c0394360 unknown_bootoption+0x0/0x1e0
> 
> tw_interrupt wasn't actually modified.  However, it should have executed
> another call, probably where it's doing a null ptr deref, probably in
> one of the completion routines, which should be identified by the EIP;
> could you tell me what this is?
> 

Sorry for the long delay with the response: I'm very limited in time during
the weekdays :(

Here is the info you asked for:

EFLAGS: 00010293
EIP is at tw_scsiop_mode_sense_complete+0xc7/0xe0
eax: 00000000 ebx: c03d4e00 ecx: 00000000 edx: 00000004
esi: dfca2400 edi: c03d4e04 ebp: 00000000 esp: c0393ef4
ds: 007b es: 007b ss:0068
Process swapper (pid: 0, threadinfo=c0392000, task=c031aba0)

Again I've wrote it down manually, so typos are possible.

Hope you'll find it useful.

Thank you,
	Nick Orlov.

-- 
With best wishes,
	Nick Orlov.

