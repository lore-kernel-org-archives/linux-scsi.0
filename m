From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/16]  qla2xxx: update qla2xxx driver to 8.01.02-k.
Date: Thu, 13 Oct 2005 16:15:34 -0700 (PDT)
Message-ID: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:22434 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932525AbVJMXPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:15:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

Here's a set of patches which add a handful of features to the qla2xxx
driver.  Please queue for post-2.6.14 inclusion.

With the exception of the rather large firmware image updates (direct
pointer to bzip'd patch listed -- noted below with '*'), subsequent
messages will contain inlined patches.

Summary of patches:

  Correct issue where fcport is prematurely marked DEAD.
  Add support to dynamically enable/disable ZIO.
  Collapse ISP2xxx queuecommand implementations.
  Update license.
  Add support for embedded ISP24xx firmware.
* Resync with latest released firmware -- 4.00.12.
  Add hotplug firmware-load support for all ISP types.
* Resync with latest released ISP23xx/63xx firmware -- 3.03.18.
  Use midlayer's int_to_scsilun() function.
  Correct fw-loader module-use referencing.
  Add an 'Issue LIP' device attribute.
  Update version number to 8.01.02-k.

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.02k/

Regards,
Andrew Vasquez
QLogic Corporation

-- 
Andrew Vasquez
