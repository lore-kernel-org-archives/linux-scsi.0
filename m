From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: RE: [PATCH 0/3] Follow-on patches to
 "adding support to FCoE transport"
Date: Tue, 4 Jan 2011 23:57:59 +0000
Message-ID: <1294185479.4676.583.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
References: <1293168950.4676.508.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
 <7C88852EF6F99F4EB538472FCFEBE222014A4783B3@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1890 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab1ADX6J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2011 18:58:09 -0500
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE222014A4783B3@orsmsx509.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

On Tue, 2011-01-04 at 15:32 -0800, Zou, Yi wrote:

> Cool, if it's ok w/ you, I can merge the three patches into the original
> series and repost as RFC v2, I will fix the fcoe_parse_buffer() as mentioned
> above, and your v2 of bnx2fc patches should not be affected.

Thanks for the review, Yi. 

I agree with your fix for fcoe_parse_buffer() to support older
fcoe-utils.  You can merge those changes.

We'll try to submit the patch for the modified fcoe-utils soon.

Thanks again,
Bhanu




