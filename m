From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: qla2300 read buffer problems
Date: Tue, 12 Jul 2005 17:31:06 -0400
Message-ID: <1121203866.5026.10.camel@mulgrave>
References: <24233.1121179331@www63.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:9893 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262445AbVGLVbP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 17:31:15 -0400
In-Reply-To: <24233.1121179331@www63.gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rother-ml@gmx.de
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-07-12 at 16:42 +0200, rother-ml@gmx.de wrote:
> Info: DiagRWBufferTest: Sense Key:  0xe, asc:  0x1d, ascq:  0x0.

That's a miscompare error with asc/ascq specifying miscompare on
verify ... it shouldn't be the product of a READ_BUFFER command it
should be the product of a VERIFY command, so there might be something
wrong with your storage.

James


