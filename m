From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5] scsi: megaraid_sas - Version and documentation
 update
Date: Tue, 26 Oct 2010 11:12:23 -0500
Message-ID: <1288109543.8283.139.camel@mulgrave.site>
References: <AANLkTi=praySm1B3dhU+LxhWK2yUccZkzWpd6-6UERYa@mail.gmail.com>
	 <4B6A08C587958942AA3002690DD4F8C30100FF9FBB@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759910Ab0JZQM3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 12:12:29 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30100FF9FBB@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: bo yang <boyang1288@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, 2010-10-12 at 07:21 -0600, Yang, Bo wrote:
> Re-Submit:
> 
> Update the version and documentation.

This has an impressive set of checkpatch failures:

ERROR: trailing whitespace
#26: FILE: Documentation/scsi/ChangeLog.megaraid_sas:13:
+^ITo add the OCR support, driver need to do: $

ERROR: trailing whitespace
#30: FILE: Documentation/scsi/ChangeLog.megaraid_sas:17:
+^I^I$

ERROR: trailing whitespace
#35: FILE: Documentation/scsi/ChangeLog.megaraid_sas:22:
+^I^I$

ERROR: trailing whitespace
#39: FILE: Documentation/scsi/ChangeLog.megaraid_sas:26:
+^I^I$

ERROR: trailing whitespace
#43: FILE: Documentation/scsi/ChangeLog.megaraid_sas:30:
+^I^I$

ERROR: trailing whitespace
#46: FILE: Documentation/scsi/ChangeLog.megaraid_sas:33:
+^I^I $

ERROR: trailing whitespace
#48: FILE: Documentation/scsi/ChangeLog.megaraid_sas:35:
+^I^IOCR to see if driver can bring back the FW.      $

ERROR: trailing whitespace
#54: FILE: Documentation/scsi/ChangeLog.megaraid_sas:41:
+3.^IIn driver's timeout routine, driver will do three time reset if fw
is in $

total: 8 errors, 0 warnings, 70 lines checked

I've fixed it up this time, but could you run it through checkpatch.pl
next time?

Thanks,

James


