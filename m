From: Olaf Hering <olh@suse.de>
Subject: sysfs support for sg
Date: Wed, 7 Jan 2004 23:33:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040107223341.GA23799@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:20907 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265647AbUAGWdn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2004 17:33:43 -0500
Received: from Hermes.suse.de (Hermes.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id 67AA219A87AF
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2004 23:33:42 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Olaf Hering <olh@suse.de>

Hello,

are there any plans to add sysfs support to the sg driver?
I see no 'dev' nodes for it.
Can stuff like 'sg_start /dev/sg2 0' be done in another way?

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
