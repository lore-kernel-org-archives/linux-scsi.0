From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] exposing the sdev_target in sysfs
Date: 04 Sep 2004 09:54:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094306082.1924.0.camel@mulgrave>
References: <1094254851.1712.28.camel@mulgrave>
	<41394901.3050804@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44503 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263735AbUIDNyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Sep 2004 09:54:44 -0400
In-Reply-To: <41394901.3050804@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-09-04 at 00:48, Mike Christie wrote:
> device_add calls kobject_add which can sleep.

Yes, I'll move it outside the lock.

I suppose I should add a comment somewhere about our critical dependence
on sequential LUN scanning as well just in case someone tries to
parallelise it.

James


