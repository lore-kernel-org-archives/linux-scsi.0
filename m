From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 19:36:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629173632.GA15024@win.tue.nl>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kweetal.tue.nl ([131.155.3.6]:62990 "EHLO kweetal.tue.nl")
	by vger.kernel.org with ESMTP id S265706AbTF2RWO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 13:22:14 -0400
Content-Disposition: inline
In-Reply-To: <3EFF14BD.3030406@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 29, 2003 at 12:33:01PM -0400, Jeff Garzik wrote:
> Andries Brouwer wrote:
> >The firmware of existing devices is not magically updated when
> >a new draft standard is released. So reading yesterdays version
> >gives very little information on the real world.
> 
> I'm not implying otherwise...  I just think a hueristic can be found 
> that works with these devices.
> 
> 
> >[And no, none of my USB devices announces MMC-4 compliance.]
> 
> Would you mind posting the first 8 bytes of any of these USB storage 
> devices' INQUIRY pages?
> 

Two that I have right here yield 0 80 2 2 20 0 0 0 and
0 80 0 2 1F 0 0 0, respectively. (All in hex.)

The 20 in the first is a bug - the INQUIRY gives only 36 bytes.

You do not make me happy with wonderful SCSI patches right now.
I like to go slowly.

[I did introduce this use_10_for_ms; it allows a very large
cleanup in the usb-storage code. Submitted the SCSI part of
the patch and waited for it to be applied. That took a while
and when it went in I was a bit short on Linux time. So Matt
got impatient and started doing the rest himself. He patched
sr.c - something I would not have done, I considered the SCSI
part settled - perhaps things broke a bit but James went in and
fixed some things again. So maybe we are now again ready for
the intended large cleanup. I would like to see that done,
and afterwards see this area stable for a few kernel versions.]

Andries

