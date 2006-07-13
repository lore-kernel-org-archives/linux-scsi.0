From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/2] libata: Support SATA attached via SAS
Date: Thu, 13 Jul 2006 08:35:29 -0500
Message-ID: <44B64C21.6070705@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:20697 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751485AbWGMNfe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 09:35:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff,

Here are the remaining 2 patches to my patchset to allow SAS HBAs to
use libata to control attached SATA devices. The last two issues you brought
up have been addressed as follows:


1. Per device max command length checking
   - This has been removed.

2. Add ata_host_flags
   - You thought there might be a need to carry some cross port state.
     To resolve this I added a new API: ata_host_set_init. Callers
     of ata_sas_port_alloc must now pass their host_set pointer as the
     first argument. This removes the need for the patch you objected to
     and allows for a cross port state if needed.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
