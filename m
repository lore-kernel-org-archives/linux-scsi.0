From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: 21 Sep 2004 12:33:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095784395.2507.195.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org>
	<20040921162535.GB11446@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:36328 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267829AbUIUQdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:33:35 -0400
In-Reply-To: <20040921162535.GB11446@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, 2004-09-21 at 12:25, Matthew Wilcox wrote:
>    Configuration writes are not posted. (I/O writes can be posted in the
>    Host Bridge, but some restrictions apply.) Read transactions (Memory,
>    I/O, or Configuration) are not posted.

Erk, depending on what "some restrictions apply" means, that blows a
hole in the idea of using PIO writes to guarantee no posting.

James


