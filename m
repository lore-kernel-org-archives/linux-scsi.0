From: harlan@artselect.com (Pete Harlan)
Subject: 2.6.8.1 aacraid/commctrl.c warning, gcc 3.4, x86_64
Date: Wed, 25 Aug 2004 17:40:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825224051.GT10720@artselect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from peacekeeper.artselect.com ([69.18.47.2]:27104 "EHLO
	wyeth.artselect.com") by vger.kernel.org with ESMTP id S266198AbUHYWk4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 18:40:56 -0400
Received: from klimt.artselect.com (klimt.artselect.com [192.168.2.34])
	by wyeth.artselect.com (Postfix) with ESMTP id B64A4C370
	for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2004 17:40:51 -0500 (CDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Compiling kernel 2.6.8.1 with gcc-3.4.1 (Debian 3.4.1-5) on x86_64,
gives the following warning:

  CC      drivers/scsi/aacraid/commctrl.o
drivers/scsi/aacraid/commctrl.c: In function `aac_send_raw_srb':
drivers/scsi/aacraid/commctrl.c:562: warning: cast to pointer from integer of different size

The line in question is:

			sg_user[i] = (void __user *)(psg->sg[i].addr);

The driver appears to work.

I apologize if this is already known; I'm not on this list (the email
address is in the MAINTAINERS file.)

HTH,

--Pete
