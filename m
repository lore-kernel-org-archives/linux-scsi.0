From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: qla2xxx: fixes for 2.6.25.
Date: Thu, 28 Feb 2008 14:05:09 -0800
Message-ID: <20080228220509.GE18083@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21170 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYB1WFX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 17:05:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

James,

Here's s small handful of fixes for qla2xxx.

- Correct needless clean-up resets during shutdown.
- Correct discrepancies during OVERRUN handling on FWI2-capable cards.
- Correct usage of inconsistent timeout values while issuing ELS commands.
- Update version number to 8.02.00-k9.

Please apply.

Regards,
Andrew Vasquez
