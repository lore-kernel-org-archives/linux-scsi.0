From: "Styner, Douglas W" <douglas.w.styner@intel.com>
Subject: RE: [PATCH] qla2xxx: Resolved a performance issue in interrupt
Date: Fri, 12 Jun 2009 15:48:22 -0700
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260354169369@azsmsx501.amr.corp.intel.com>
References: <B8134F80-B547-4E04-890A-6B646D2BA3E8@qlogic.com>
  <20080911201140.GM2772@parisc-linux.org>
  <20090610183259.GI89096@n6013ncj7y1lh1.qlogic.org>
 <1244661018.17432.21.camel@mulgrave.site>
 <alpine.OSX.1.00.0906101349480.5521@ac-mac.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760227AbZFLWsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 18:48:21 -0400
In-Reply-To: <alpine.OSX.1.00.0906101349480.5521@ac-mac.local>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, David Wagner <david.wagner@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Prickett, Terry O" <terry.o.prickett@intel.com>

Anirban Chakraborty [mailto:anirban.chakraborty@qlogic.com] writes:
>
>This is the updated patch. Please apply.

Performance results from this patch compared to 2.6.30-rc6_scsi-misc.

