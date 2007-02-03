From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bugme-new] [Bug 7919] New: Tape dies if wrong block size used
Date: Sat, 3 Feb 2007 18:35:27 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0702031827070.6410@kai.makisara.local>
References: <200702012334.l11NYTWu010618@fire-2.osdl.org>
 <20070201160858.ef28f354.akpm@osdl.org>  <Pine.LNX.4.64.0702031307480.6410@kai.makisara.local>
 <1170511444.3345.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:59933 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946491AbXBCQcs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 11:32:48 -0500
In-Reply-To: <1170511444.3345.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, dmartin@sccd.ctc.edu

On Sat, 3 Feb 2007, James Bottomley wrote:

> On Sat, 2007-02-03 at 13:21 +0200, Kai Makisara wrote:
> > This patch may also fix the bug 7900.
> > 
> > The patch compiles and is lightly tested.
> 
> We can give it a spin in scsi-misc ... do you want me to hold off from
> sending it upstream with the scsi-misc tree when 2.6.20 is declared?
> 
You can send it upstream after 2.6.20 is out. I am actually very happy 
with the patch. Conceptually it is very simple and based on mechanisms 
existing in the driver. In addition to fixing the bug in this report, it 
removes the last difference in user space sematics between direct i/o and 
using the driver buffer. (No documentation change needed because 
Documentation/scsi/st.txt has not mentioned this difference ;-)

-- 
Kai
