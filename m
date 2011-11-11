From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: aacraid controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 08:41:24 -0600
Message-ID: <1321022484.5161.16.camel@dabdike.int.hansenpartnership.com>
References: <4EBCEDED.7030907@parallels.com>
	 <20111111130938.GA10242@srcf.ucam.org>
	 <1321020913.5161.15.camel@dabdike.int.hansenpartnership.com>
	 <FC1F9E38C0703341A1A750524E2525A9018F95B1@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42941 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906Ab1KKOl1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 09:41:27 -0500
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018F95B1@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Vasily Averin <vvs@parallels.com>, linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>

On Fri, 2011-11-11 at 06:20 -0800, Mark Salyzyn wrote:
> Aacraid is *not* out of production, there is just a long legacy of EOL'd
> cards. PMC is continued developing and extending the hardware (Series 6
> and beyond)

OK, I'll amend the statement to PMC will add the discriminator for the
new cards in the driver when they've verified that PCIe link power
management is working with them.

James


