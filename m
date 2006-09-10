From: David Miller <davem@davemloft.net>
Subject: Re: [Bugme-new] [Bug 7130] New: loading driver eat all CPU and
 since some time may block all system disk IO (even can not reboot)
Date: Sun, 10 Sep 2006 06:11:40 -0700 (PDT)
Message-ID: <20060910.061140.74736819.davem@davemloft.net>
References: <200609091032.k89AW7bM017561@fire-2.osdl.org>
	<20060909083631.95a63528.akpm@osdl.org>
	<1157817856.3462.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:42917
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S932125AbWIJNLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Sep 2006 09:11:02 -0400
In-Reply-To: <1157817856.3462.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, wizard580@gmail.com, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Sat, 09 Sep 2006 11:04:15 -0500

> On Sat, 2006-09-09 at 08:36 -0700, Andrew Morton wrote:
> > Does anyone else us the fcal driver?
> > 
> > I'd suggest the next step would be to run a kernel profile, or just sysrq-P
> > to find out where the CPU is stuck.  Could a sparc person please talk the
> > reporter through that process?
> 
> I'm not sure this is really worth it.  Apart from trying to keep it
> compiling, fcal has had no maintainer since the 2.2 kernel days.  Since
> no-one has the hardware or the inclination, it's not plugged into the
> SCSI FC infrastructure and thus it's bitrotting.

I think it's not feasible nor worth plugging the fcal driver into the
SCSI FC infrastructure right now simply because these drivers need a
full software FC stack, and the SCSI FC stuff just provides very high
level interfaces to all of this an expects on-board firmware to do all
the protocol packet building and other FC stuff just like the
Qlogic-FC and other cards do.

So it's not just a matter of "porting fcal to SCSI FC", someone would
need to implement the full FC software stack.

