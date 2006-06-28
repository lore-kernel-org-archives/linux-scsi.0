From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/3] ipr: Support SATA devices
Date: Wed, 28 Jun 2006 08:46:21 -0500
Message-ID: <44A2882D.90904@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54420 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932805AbWF1NqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 09:46:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

The following patchset adds support to ipr to attach SATA
devices using the new libata interfaces in my previous patchset.
The first two patches do not have any dependence on the libata
changes and can be applied to scsi-misc right away. The last
patch has to wait until the libata patchset is merged.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
