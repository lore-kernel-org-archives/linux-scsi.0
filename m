From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: [PATCH 0/11] qla4xxx-v5.00.05b5-k : Addresses issues reported as part of initial RFC
Date: Thu, 9 Mar 2006 13:24:21 -0800
Message-ID: <3679966B84813344B908D418BA3F6A4A06F604C2@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:49000 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751759AbWCIVYV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 16:24:21 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Following set of patches addresses the issues reported by Arjan, plus
some additional bug fixes. Looking forward for further feedback and suggestions.

-Use-msleep-rather-than-schedule_timeout.txt
-Drop-IPAddr-functions.txt
-Drop-unused-defines.txt
-Consolidate-include-definitions.txt
-Correct-allocations-of-ddb_entry.txt
-Change-semaphore-usage-to-mutex.txt
-Fixed-logic-to-skip-device-discovery-if-IP-Addr-and-Subnet-Mask-is-Zero.txt
-Updated-Comment-at-the-head-of-the-func-s.txt
-Drop-Unused-Code.txt
-Update-Driver-Version-to-5.00.05b5-k.txt
-Updated-scsi-Kconfig-to-include-qla4xxx-Kconfig-path.txt

Thanx
Ravi Anand
QLogic Corporation
