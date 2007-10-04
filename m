From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: generating a Linux WWN?
Date: Wed, 3 Oct 2007 21:33:26 -0600
Message-ID: <20071004033326.GJ12049@parisc-linux.org>
References: <20071003.151729.95504687.davem@davemloft.net> <189434.76759.qm@web31810.mail.mud.yahoo.com> <7579f7fb0710032023x6773075ga0342033e8f6f3a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56949 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbXJDDd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 23:33:29 -0400
Content-Disposition: inline
In-Reply-To: <7579f7fb0710032023x6773075ga0342033e8f6f3a4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <lydianconcepts@gmail.com>
Cc: ltuikov@yahoo.com, David Miller <davem@davemloft.net>, jeff@garzik.org, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On Wed, Oct 03, 2007 at 08:23:14PM -0700, Matthew Jacob wrote:
> For smaller bit spaces like 64 bit WWNs, you cannot, as you correctly
> point out, generate reliably unique numbers all by youself. The
> closest you could probably come is using a type 5 WWN with a known
> single OUI and then use "seconds since January 1 2007" as a serial
> number in the 36 bit VID space that gives you about 8 years before it
> wraps- the likely collision rate here would be pretty low.

Unless you generate more than one WWN per second.  We could enforce that
by have an msleep(1000) in the WWN generator function ... which might
discourage people from using it except when they really had to ;-)
Of course, if you turn on two computers in the same zone at the same
time, you're still screwed.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
