From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/1] Remove of old NCR53C9x/esp family of drivers
Date: Thu, 03 Jan 2008 17:17:43 +0200
Message-ID: <477CFC97.2010201@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31722 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176AbYACPSN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 10:18:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, "David S. Miller" <davem@davemloft.net>, Linux/m68k

James 
  Could you at least put the following patch in scsi-pending
so it can attract some acknowledgment, and retract futile
attempts from people at coding these drivers.
(And also git is better than me in maintaining it synced)

Christoph Hellwig!
  I need your Recommended-by: on this. I had my regular
convert-to-accessors, and because of your recommendation
I'm pushing this removal. And I keep doing it again and again
because a removal patch is a conflict-to-any by definition.


David S. Miller & Maciej W. Rozycki
  Please add a comment in favor of this move. And a few words for
the few users left for this hardware.

Boaz
