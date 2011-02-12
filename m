From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/06] mptfusion: (New Feature)Added new sysfs
 parameters for handle and firmware id
Date: Sat, 12 Feb 2011 13:55:06 -0600
Message-ID: <1297540506.3026.27.camel@mulgrave.site>
References: <20110210061934.GB31424@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58752 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab1BLTzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Feb 2011 14:55:09 -0500
In-Reply-To: <20110210061934.GB31424@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Thu, 2011-02-10 at 11:49 +0530, Kashyap, Desai wrote:
> New feature is added.  sas_device_hanlde and firmware id will be visible from 
> sysfs parameters. handle and firmware id is internal to LSI firmware.
> It is merely debugging purpose.

Broken record time: checkpatch.pl:

WARNING: please, no space before tabs
#21: FILE: drivers/message/fusion/mptbase.h:402:
+^Iu16     ^I^I handle;$

WARNING: please, no spaces at the start of a line
#67: FILE: drivers/message/fusion/mptscsih.c:3350:
+    char *buf)$

ERROR: code indent should use tabs where possible
#79: FILE: drivers/message/fusion/mptscsih.c:3362:
+ ^I^INULL);$

WARNING: please, no space before tabs
#79: FILE: drivers/message/fusion/mptscsih.c:3362:
+ ^I^INULL);$

WARNING: please, no spaces at the start of a line
#79: FILE: drivers/message/fusion/mptscsih.c:3362:
+ ^I^INULL);$

WARNING: please, no spaces at the start of a line
#91: FILE: drivers/message/fusion/mptscsih.c:3374:
+    char *buf)$

ERROR: code indent should use tabs where possible
#103: FILE: drivers/message/fusion/mptscsih.c:3386:
+ ^I^INULL);$

WARNING: please, no space before tabs
#103: FILE: drivers/message/fusion/mptscsih.c:3386:
+ ^I^INULL);$

WARNING: please, no spaces at the start of a line
#103: FILE: drivers/message/fusion/mptscsih.c:3386:
+ ^I^INULL);$

total: 2 errors, 7 warnings, 93 lines checked

Also, as I read through this patch, doesn't it add these two parameters
for every fusion device type (SPI, SAS and FC) but only set them for
SAS?  If you want SAS only parameters, they should probably be visible
only for SAS cards.

James


