From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/7] lpfc 8.3.36: Update lpfc to revision 8.3.36
Date: Wed, 31 Oct 2012 14:44:21 -0400
Message-ID: <1351709061.957.15.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:15742 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759642Ab2JaSpE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 14:45:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.36

The patches for 8.3.36 contain:

- Fixed boot from san failure 
- Fix bug with Target Resets and FCP2 devices
- Update DIF support for passthru/strip/insert
- Fixed setting sequential delivery bit 
- Correct buffer length overrun.
- Correct mask error
- Update lpfc version for 8.3.36 driver release


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>






