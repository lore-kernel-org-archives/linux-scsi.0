From: Anton Blanchard <anton@samba.org>
Subject: Why does lpfc select GENERIC_CSUM?
Date: Mon, 5 Aug 2013 20:20:17 +1000
Message-ID: <20130805202017.651b6cfd@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:54714 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3HEKU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Aug 2013 06:20:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, JBottomley@parallels.com


Hi Randy,

commit 6a7252fd ([SCSI] lpfc: fix up Kconfig dependencies) added a
select of GENERIC_CSUM. This seems strange to me - it's an architecture
specific detail if the checksum routines are implemented in assembly or
if they pull in lib/checksum.c.

The networking code doesn't select GENERIC_CSUM, so I'm not sure why
the lpfc driver needs to. Was there a real issue we hit here?

Regards,
Anton
