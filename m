From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_dd bpt= count=
Date: 21 Oct 2003 13:44:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066765478.2812.44.camel@patehci2>
References: <1066174844.3399.6.camel@patehci2>
	 <1066674092.2833.0.camel@patehci2> <1066679354.2833.66.camel@patehci2>
	 <3F947565.1030804@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:46842 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263259AbTJUTos
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2003 15:44:48 -0400
In-Reply-To: <3F947565.1030804@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> Applied to sg3_utils. Also added a check for non-positive bpt.
> There is a new beta on http://www.torque.net/sg

Perfect, thanks.

Pat LaVarre

P.S. More specifically:

In a Linux built without linux-scsi "[PATCH] SG_SET_RESERVED_SIZE
negative oops", now rather than oops I see:

$ sg_dd of=/dev/sg0 if=/dev/zero bs=2k bpt= count=
bpt must be greater than 0
$

Also: diff -Nur sg3_utils-1.05-was sg3_utils-1.05
tells me:
+  - sg_dd, sgp_dd, sgm_dd, sg_read, sg_turs: require bpt > 0


