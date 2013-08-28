From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 02/29] qla2xxx: Add support for ISP8044.
Date: Wed, 28 Aug 2013 07:15:09 +0000
Message-ID: <1377674108.2005.32.camel@dabdike>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
	 <1377581875-8574-3-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:50983 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab3H1HPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 03:15:16 -0400
In-Reply-To: <1377581875-8574-3-git-send-email-saurav.kashyap@qlogic.com>
Content-Language: en-US
Content-ID: <63F9501DD80B37418474462AD2E1A167@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2013-08-27 at 01:37 -0400, Saurav Kashyap wrote:
> From: Atul Deshmukh <atul.deshmukh@qlogic.com>

You seem to have stopped running your stuff through checkpatch:

WARNING: please, no spaces at the start of a line
#317: FILE: drivers/scsi/qla2xxx/qla_gbl.h:479:
+    uint8_t *, uint32_t, uint32_t);$

WARNING: please, no spaces at the start of a line
#341: FILE: drivers/scsi/qla2xxx/qla_gbl.h:713:
+    const uint32_t crb_reg, const uint32_t value);$

WARNING: please, no spaces at the start of a line
#351: FILE: drivers/scsi/qla2xxx/qla_gbl.h:723:
+    uint32_t, uint32_t);$

WARNING: please, no spaces at the start of a line
#3175: FILE: drivers/scsi/qla2xxx/qla_nx2.c:2084:
+    struct qla8044_minidump_entry_hdr *entry_hdr)$

WARNING: please, no spaces at the start of a line
#4258: FILE: drivers/scsi/qla2xxx/qla_nx2.c:3167:
+    uint32_t data)$

WARNING: please, no spaces at the start of a line
#4334: FILE: drivers/scsi/qla2xxx/qla_nx2.c:3243:
+    uint32_t sector_start_addr)$

WARNING: please, no spaces at the start of a line
#4390: FILE: drivers/scsi/qla2xxx/qla_nx2.c:3299:
+    uint32_t *p_data)$

WARNING: please, no spaces at the start of a line
#4425: FILE: drivers/scsi/qla2xxx/qla_nx2.c:3334:
+    uint32_t faddr, uint32_t dwords)$

WARNING: please, no spaces at the start of a line
#4508: FILE: drivers/scsi/qla2xxx/qla_nx2.c:3417:
+    uint32_t faddr, uint32_t dwords)$

WARNING: please, no spaces at the start of a line
#4528: FILE: drivers/scsi/qla2xxx/qla_nx2.c:3437:
+    uint32_t offset, uint32_t length)$

total: 0 errors, 10 warnings, 5781 lines checked

Please don't; those are all legitimate problems.

James

