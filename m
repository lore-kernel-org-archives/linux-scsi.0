From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: 2.6.0-test9-bk26 fails boot -- aic7890 detection
Date: 22 Nov 2003 13:10:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069528226.1664.5.camel@mulgrave>
References: <200311221509.KAA07051@clem.clem-digital.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:9733 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262686AbTKVTK7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 14:10:59 -0500
In-Reply-To: <200311221509.KAA07051@clem.clem-digital.net>
List-Id: linux-scsi@vger.kernel.org
To: Pete Clements <clem@clem.clem-digital.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2003-11-22 at 09:09, Pete Clements wrote:
> 2.6.0-test9-bk26 boot hangs after ide detection. Next detect normally
> scsi AIC7XXX.  Has been good for all prior test9-bk's.

I'm assuming bk26 contains the latest set of SCSI diffs (they were
merged on 21 Nov around 14:00 PST)?

I've never successfully managed to get the aic7xxx driver to work on my
parisc platform.  However, both with and without the latest SCSI diffs
the behaviour seems the same (it does print out the driver banner before
failing to connect to the drives).  I take it you aren't seeing this
banner?

James


