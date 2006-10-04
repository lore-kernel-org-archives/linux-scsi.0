From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [RFC] [PATCH] qla4xxx driver resubmission
Date: Wed, 04 Oct 2006 11:39:44 -0500
Message-ID: <1159979985.3437.14.camel@mulgrave.il.steeleye.com>
References: <0BB3E5E7462EEA4295BC02D49691DC074A403C@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:12993 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161243AbWJDQkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 12:40:10 -0400
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC074A403C@AVEXCH1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, David Wagner <david.wagner@qlogic.com>

On Wed, 2006-10-04 at 09:30 -0700, David Somayajulu wrote:
> Thanks a lot James. My apologies for the inconvenience pertaining to
> whitespaces. For future, is there any tool out there which one run, to
> sanitize the code before submission.

Quilt and git both warn about this ... which is how I noticed it in the
first place.

James


