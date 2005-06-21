From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 12:24:49 -0700
Message-ID: <20050621192449.GA30526@us.ibm.com>
References: <1118930260.4998.6.camel@mulgrave> <Pine.LNX.4.44L0.0506181554270.3347-100000@netrider.rowland.org> <20050621171209.GB29396@us.ibm.com> <20050621174301.GA726@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:6564 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262233AbVFUTY3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 15:24:29 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5LJOTHb016929
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 15:24:29 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5LJOTKK152188
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 15:24:29 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5LJOSjA012699
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 15:24:28 -0400
Content-Disposition: inline
In-Reply-To: <20050621174301.GA726@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Patrick Mansfield [patmans@us.ibm.com] wrote:
> Mike -
> 
> You probably need Alan's most recent patch that passes through
> scsi_scan_target's parent argument.

Yes, thanks I thought that I was running the third update, but I was
running the second one. Running with third patch update fixes my scan
issue.

-andmike
--
Michael Anderson
andmike@us.ibm.com

