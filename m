From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [RFC] [PATCH] qla4xxx driver resubmission
Date: Wed, 04 Oct 2006 10:49:46 -0500
Message-ID: <1159976986.3437.12.camel@mulgrave.il.steeleye.com>
References: <0BB3E5E7462EEA4295BC02D49691DC07414C2E@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6592 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161259AbWJDPuP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 11:50:15 -0400
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC07414C2E@AVEXCH1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, David Wagner <david.wagner@qlogic.com>

On Fri, 2006-09-29 at 17:42 -0700, David Somayajulu wrote:
> Once again, we would really appreciate if you could please let us know
> the status of qla4xxx driver regarding its inclusion upstream.

OK, I have this (it won't go to scsi-misc until Jens pushes the block
changes on which it depends).

However, there was a tonne of trailing whitespace I had to remove:

Warning: trailing whitespace in line 6 of drivers/scsi/qla4xxx/Kconfig
Warning: trailing whitespace in lines 173,543,544,801,802 of
drivers/scsi/qla4xxx/ql4_mbx.c
Warning: trailing whitespace in lines 587,712 of
drivers/scsi/qla4xxx/ql4_isr.c
Warning: trailing whitespace in lines 491,896,1147,1176,1439 of
drivers/scsi/qla4xxx/ql4_os.c
Warning: trailing whitespace in lines 44,363,481,527,1135 of
drivers/scsi/qla4xxx/ql4_init.c

James


