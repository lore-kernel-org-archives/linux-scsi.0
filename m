From: krike@sci.fi
Subject: Userspace scsi.h type mismatch.
Date: Thu, 21 Jan 2010 20:29:51 +0200
Message-ID: <20100121182951.GA2746@satellite>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:49952 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0AUShe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2010 13:37:34 -0500
Received: from localhost (YYMYCVI.gprs.sl-laajakaista.fi [85.76.217.7])
	by gw01.mail.saunalahti.fi (Postfix) with ESMTP id 61F2F151407
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jan 2010 20:29:53 +0200 (EET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello.

 I think that there is mistake in linux/2.6.32.4/include/scsi/scsi.h:

 the first type defination of u8 should be type of __u8 on userspace
 (struct scsi_varlen_cdb_hdr).

 I founded this problem when I try compile the util-linux-ng-2.17.
 This should cause problems many other packages also that includes scsi.h

Best regards: Kristian Rainio <krike@sci.fi>
