From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi: megaraid_sas - intercepts cmd timeout
	andthrottle io
Date: Thu, 26 Apr 2007 15:28:27 -0400
Message-ID: <1177615707.6284.135.camel@mulgrave.il.steeleye.com>
References: <0631C836DBF79F42B5A60C8C8D4E8229A5922C@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48419 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754945AbXDZT2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 15:28:39 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229A5922C@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

On Thu, 2007-04-26 at 11:52 -0600, Patro, Sumant wrote:
>         The rsvd[3] is reserved for future use. If you have objection to
> the definition I will take it out in a future patch submission.

But this is a structure that's internal to the driver isn't it?  It's
not shared with the card, so there's no need to pad it or reserve
elements ... you can add anything you need at the point you need it.

James


