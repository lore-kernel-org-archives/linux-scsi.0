From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: qla2xxx tcq question/bug
Date: 09 Jul 2004 21:44:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089427459.2342.149.camel@mulgrave>
References: <40EF2697.20804@us.ibm.com>
	<20040709234644.GB14787@praka.san.rr.com>
	<20040709235443.GA14953@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:20445 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266105AbUGJCom (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 22:44:42 -0400
In-Reply-To: <20040709235443.GA14953@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: Mike Christie <mikenc@us.ibm.com>, andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-07-09 at 18:54, Andrew Vasquez wrote:
> BTW: 53c700.c appears to be the only scsi driver which calls
> scsi_activate_tcq()???

That would be because two years ago the scsi maintainer tried to make it
an example to other driver writers of how to use the block layer tag
command queueing.

You could say that was one of the less successful instances of leading
by example...

James


