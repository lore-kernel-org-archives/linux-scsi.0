From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: Kernel 2.6.7-mm4 -bk11
Date: 29 Jun 2004 15:52:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088542328.1861.41.camel@mulgrave>
References: <20040629133906.28af7568.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:52152 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266017AbUF2UwW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2004 16:52:22 -0400
In-Reply-To: <20040629133906.28af7568.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-06-29 at 15:39, Andrew Morton wrote:
> i missing in Kernel 2.6.7-mm4 and -bk11 the config for driver

It's currently listed as BROKEN because it's emitting a #warning
reminding us that the conversion to the DMA API still isn't completed.

James


