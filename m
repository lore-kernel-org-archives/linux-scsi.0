From: Ingo Flaschberger <if@xip.at>
Subject: cpqfc gone - all compay RA4X00 Array now useless in linux?
Date: Mon, 6 Feb 2006 18:46:29 +0100 (CET)
Message-ID: <Pine.GSO.4.64.0602061840520.24390@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:59069 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S932229AbWBFSOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 13:14:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey,

I'm very very sorry that the cpqfc driver is gone because it was the 
_only_ one which supported the now very cheap Compaq FiberChannel Array 
RA4X00.

With all other FC HBA's the logical volumes (LUN's) are not visible.
---snip---
5. Compaq RA4x00 firmware version 2.54 and later supports SSP (Selective
Storage Presentation), which maps LUNs to a WWN.  If RA4x00 firmware prior
2.54 (e.g. older controller) is used, or the FC HBA is replaced (another WWN
is used), logical volumes on the RA4x00 will no longer be visible.
---snap---

So... there are 3 possibilities:
1. Repair the cpqfc driver and but it again into linux?
2. Find out, how to get the RA4x00 arrays with othet HBA's running; I
 	searched about 1 week in Google, no way..
3. Aeh.. use... 2.4, use... other OS?

Hope to find a way... and not only kicking a working driver because of not 
as nice code and to much stack memory.

bye,
 	ingo flaschberger

geschaeftsleitung
crossip communications gmbH
------------------------------
sebastian kneipp gasse 1
a-1020 wien
fix: +43-1-726 15 22-217
fax: +43-1-726 15 22-111
mob: +43-699-105 86 719
www.xip.at
------------------------------
