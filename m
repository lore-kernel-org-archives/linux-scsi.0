From: "Sagar Shinde" <sagar.shinde@patni.com>
Subject: scsi_error_handler  kernel thread
Date: Thu, 3 Feb 2005 20:53:28 +0530
Message-ID: <EGEELICONHJFEACGEOAIAEBECBAA.sagar.shinde@patni.com>
Reply-To: <sagar.shinde@patni.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1107444421-18113-165"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcsbom.patni.com ([203.124.139.208]:16537 "EHLO
	pcsspz.PATNI.COM") by vger.kernel.org with ESMTP id S263291AbVBCP0w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 10:26:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: lkg_india <lkg_india@yahoogroups.com>

This is a multi-part message in MIME format...

------------=_1107444421-18113-165
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi ,

There is a kernel thread associated with every host adapter,
which is initialised during registering the host which uses function
scsi_error_handler to handle the errors associated with the host.

Can somebody please elaborate when exactly this error tracking by 
this kernel thread takes place during i/o flow through scsi?

I mean when is this thread invoked in the flow and who invokes this thread?

Thanks and Regards,
Sagar Shinde


http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail. 
_____________________________________________________________________

------------=_1107444421-18113-165--
