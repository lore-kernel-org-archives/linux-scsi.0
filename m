From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 0/5] Series short description
Date: Mon, 25 Feb 2008 03:20:04 -0800
Message-ID: <20080225111856.22380.70951.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13115 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbYBYTkP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:40:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

The following series implements...

Currently OpenFC maintains several control structures for each enabled fcoe
interface, such as inner and outer fc_port, fcdev, openfc_softc, 
fcs_state (for fc_local_port and fc_virt_fab) etc. Here fc_port should not
be confused with FC protocol's ports related structs, instead fc_port provides 
generic/portable interface to FCS sub module embedded inside openFC 
for egress, ingress handlers and sa events lists to OpenFC per FCoE interface
instance.

I removed outer port instance in these patches, instead used existing fcdev 
structure by direct functions calls between FCS & OpenFC for outer port 
egress and inegress functions. The fcdev is key shared structure per FCoE 
interface between OpenFC and FCoE modules, fcdev can be extended for all 
libfc(TBD) users to access per libfc user instance.
 
Consolidation of more control structures in fcdev will simplify openFC
implementation which will help in converting OpenFC into generic libfc
library as suggested by linux-scsi reviewers.

-- 
Signature : Vasu Dev <vasu.dev@intel.com>
