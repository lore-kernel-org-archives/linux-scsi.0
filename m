From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [RFC] [PATCH] qla4xxx driver resubmission
Date: Wed, 4 Oct 2006 09:30:07 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC074A403C@AVEXCH1.qlogic.org>
References: <1159976986.3437.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56929 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1161555AbWJDQaI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 12:30:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1159976986.3437.12.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, David Wagner <david.wagner@qlogic.com>

> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Wednesday, October 04, 2006 8:50 AM
> To: David Somayajulu
> Cc: Mike Christie; linux-scsi@vger.kernel.org; Christoph Hellwig;
David Wagner
> Subject: RE: [RFC] [PATCH] qla4xxx driver resubmission
> 
> On Fri, 2006-09-29 at 17:42 -0700, David Somayajulu wrote:
> > Once again, we would really appreciate if you could please let us
know
> > the status of qla4xxx driver regarding its inclusion upstream.
> 
> OK, I have this (it won't go to scsi-misc until Jens pushes the block
> changes on which it depends).
> 
> However, there was a tonne of trailing whitespace I had to remove:
> 
> Warning: trailing whitespace in line 6 of drivers/scsi/qla4xxx/Kconfig
> Warning: trailing whitespace in lines 173,543,544,801,802 of
> drivers/scsi/qla4xxx/ql4_mbx.c
> Warning: trailing whitespace in lines 587,712 of
> drivers/scsi/qla4xxx/ql4_isr.c
> Warning: trailing whitespace in lines 491,896,1147,1176,1439 of
> drivers/scsi/qla4xxx/ql4_os.c
> Warning: trailing whitespace in lines 44,363,481,527,1135 of
> drivers/scsi/qla4xxx/ql4_init.c
> 
> James
> 
Thanks a lot James. My apologies for the inconvenience pertaining to
whitespaces. For future, is there any tool out there which one run, to
sanitize the code before submission.
-david S.
