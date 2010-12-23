From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCHv2 0/3] Move SCST sysfs documentation to Documentation/ABI
Date: Thu, 23 Dec 2010 19:56:54 +0100
Message-ID: <201012231956.54825.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:46300 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0LWS5H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 13:57:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Since documentation of sysfs attributes must reside in Documentation/ABI, this
series of three patches moves the documentation of the SCST sysfs attributes
to that location. Please review.

Changes since the patch set posted yesterday:
- Removed kernel version.
- All indentation is now done via tabs.
- Changed the contents of the contact field from a mailing list into the name of a person.
- Removed more redundant documentation.
