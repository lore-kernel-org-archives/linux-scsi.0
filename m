From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add missing class_device_del to transport classes
Date: Thu, 27 Jan 2005 16:33:05 -0500
Message-ID: <1106861585.5133.80.camel@mulgrave>
References: <41F82EDE.3040905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:51596 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261224AbVA0VdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 16:33:16 -0500
In-Reply-To: <41F82EDE.3040905@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-01-26 at 15:59 -0800, Mike Christie wrote:
> It appears there is a missing class_device_del.

Yes, my fault for converting it incorrectly.  What it's supposed to use
is the (nonexistent) equivalent of attribute_container_class_device_del
and attribute_container_add_class_attrs, but basically I forgot and put
them into the transport class where they shouldn't really be.

I'll fix it.

James


