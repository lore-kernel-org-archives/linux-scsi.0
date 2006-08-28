From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: convert to request_firmware interface
Date: Mon, 28 Aug 2006 09:05:18 -0500
Message-ID: <1156773918.3465.7.camel@mulgrave.il.steeleye.com>
References: <1156733286.3460.26.camel@mulgrave.il.steeleye.com>
	 <1156736843.3460.31.camel@mulgrave.il.steeleye.com>
	 <44F2E6F2.2090706@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50323 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750783AbWH1OFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 10:05:23 -0400
In-Reply-To: <44F2E6F2.2090706@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-08-28 at 08:52 -0400, Douglas Gilbert wrote:
> I presume that is a version of the infamous "razor"
> code. How do I know which version it is (before trying
> it)?

Well ... same way you do any binary blob with version text in it ... use
strings.

James


