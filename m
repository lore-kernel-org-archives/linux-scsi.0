From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add iSCSI session creation sysfs attributes
Date: Tue, 25 Jan 2005 15:08:46 -0600
Message-ID: <1106687326.6434.46.camel@mulgrave>
References: <41F4D072.5040800@cs.wisc.edu>
	 <1106580841.5513.10.camel@mulgrave>  <41F6AE02.3040400@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50867 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262158AbVAYVJA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 16:09:00 -0500
In-Reply-To: <41F6AE02.3040400@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-25 at 12:37 -0800, Mike Christie wrote:
> Will do. One question though. If a function like
> transport_add_device or transport_setup_device fails,
> how does the caller detect this?

It doesn't; the system runs degraded.

James


