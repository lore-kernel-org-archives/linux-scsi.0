From: Bart Van Assche <bvanassche@acm.org>
Subject: A few SCSI patches for 2.6.34
Date: Wed, 24 Feb 2010 18:58:27 +0100
Message-ID: <e2e108261002240958g223e9602i7854eeb574b8e292@mail.gmail.com>
References: <e2e108261002240941v33a089d5yc1843fd6b11db84c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212]:54678 "EHLO
	mail-ew0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab0BXR6j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2010 12:58:39 -0500
Received: by ewy4 with SMTP id 4so1149731ewy.28
        for <linux-scsi@vger.kernel.org>; Wed, 24 Feb 2010 09:58:37 -0800 (PST)
In-Reply-To: <e2e108261002240941v33a089d5yc1843fd6b11db84c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hello James,

Can you please have a look at the patches below ? All four patches
have been acked but have not yet been integrated in the kernel as far
as I know.

[PATCH] SCSI/libsrp: fix typo -- replace RDAM by RDMA
http://www.spinics.net/lists/linux-scsi/msg40963.html
[PATCH] SCSI/ibmvscsi: fix a typo in a source code comment
http://www.spinics.net/lists/linux-scsi/msg40964.html
[PATCH] SCSI/libsrp: fix bug in ADDITIONAL CDB LENGTH interpretation
http://www.spinics.net/lists/linux-scsi/msg41038.html
[PATCH v3] SCSI/libsrp: document the libsrp source code
http://www.spinics.net/lists/linux-scsi/msg41192.html

Bart.
