From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/16] lpfc 8.3.35: Update lpfc to revision 8.3.35
Date: Sat, 29 Sep 2012 11:28:29 -0400
Message-ID: <1348932509.23909.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:34997 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2I2PeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:34:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.35

The patches for 8.3.35 contain:

- Fix interrupt delay multipler conversion for eq_create
- Added checking BMBX register for RDY bit before writing the first address in
- Fix incorrect comment in T10 DIF attributes
- Correct missing queue destroy on function reset
- Expand I/O channel support for large systems
- Fixed Linux generic firmware download on SLI4 devices with longer module names
- Fix FCP2 Retries for non-r/w commands.
- Correct request_firmware use that was increasing boot times
- Fixed PRLI not being retried if a LS_RJT with a reason 
- Fixed kernel warning on spinlock usage on some distributions
- Fixed messages for misconfigured port errors 
- Fixed not checking solicition in progress bit when verifying FCF
  record for use
- Fixed SCSI host create showing wrong link speed on SLI3 HBA ports
- Fix error with fabric service parameters
- Fixed not reporting logical link speed to SCSI midlayer when QoS not on
- Update lpfc version for 8.3.35 driver release


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





