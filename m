From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 7919] New: Tape dies if wrong block size used
Date: Sat, 03 Feb 2007 08:04:03 -0600
Message-ID: <1170511444.3345.8.camel@mulgrave.il.steeleye.com>
References: <200702012334.l11NYTWu010618@fire-2.osdl.org>
	 <20070201160858.ef28f354.akpm@osdl.org>
	 <Pine.LNX.4.64.0702031307480.6410@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41034 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945995AbXBCOEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 09:04:15 -0500
In-Reply-To: <Pine.LNX.4.64.0702031307480.6410@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, dmartin@sccd.ctc.edu

On Sat, 2007-02-03 at 13:21 +0200, Kai Makisara wrote:
> This patch may also fix the bug 7900.
> 
> The patch compiles and is lightly tested.

We can give it a spin in scsi-misc ... do you want me to hold off from
sending it upstream with the scsi-misc tree when 2.6.20 is declared?

James

