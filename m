From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Mon, 17 Nov 2003 15:31:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117153108.51342412.rddunlap@osdl.org>
References: <20031117134140.169587af.rddunlap@osdl.org>
	<Pine.LNX.4.44.0311172331410.2258-100000@poirot.grange>
	<20031117151431.76083f58.rddunlap@osdl.org>
	<20031117232829.GR30120@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:51360 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262120AbTKQXgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 18:36:55 -0500
In-Reply-To: <20031117232829.GR30120@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: g.liakhovetski@gmx.de, hch@infradead.org, linux-scsi@vger.kernel.org, gl@dsa-ac.de

On Tue, 18 Nov 2003 00:28:29 +0100 Kurt Garloff <garloff@suse.de> wrote:

| On Mon, Nov 17, 2003 at 03:14:31PM -0800, Randy.Dunlap wrote:
| > | DC390: We were just reset and don't accept commands yet!
| > | DC390: Insert pSRB c14ec2ec cmd 0 to Waiting
| > | DC390: Debug: Waiting queue woken up by timer!
| > 
| > Does this say that the IO timed out (timer expired)?
| > I.e., the IO isn't happening?
| 
| No. If you try to send down commands after a reset, the controller
| will queue them for a second before actually trying to send them.
| That's controlled by a timer.
| (Well, with new queuing we could just refuse I guess.)

OK, I see.

| > | DC390: INQUIRY: result: 00000000
| > | DC390: Remove SRB c14ec2ec from Going
| > | DC390: Free SRB c14ec2ec
| > | scsi_delete_timer: scmd: c14c8ea8, rtn: 1
| > |   Vendor:           Model:                   Rev:
| > |   Type:   Direct-Access                      ANSI SCSI revision: 00
| > | 
| > | Whereas the 2.4 version fills in correct data for the drive. Any ideas
| > | would be appreciated.
| 
| Hmm, the INQUIRY did not yield any data :-(

Yes, that's what Guenaddi is trying to debug for now...unless
I misunderstood him.

| pci_unmap() or at least pci_sync happened at that moment already? 
| 
| All the debug stuff looks completely sane ...


--
~Randy
MOTD:  Always include version info.
