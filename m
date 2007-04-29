From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: SAVE_DATA / RESTORE_POINTERS message confusion
Date: Sun, 29 Apr 2007 22:56:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0704292249200.4454@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57693 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161034AbXD2U46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Apr 2007 16:56:58 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.36 #1 (Debian))
	id 1HiGS2-0003QH-00
	for <linux-scsi@vger.kernel.org>; Sun, 29 Apr 2007 22:56:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

looking at tmscsim (again) I cannot persuade myself that the handling of 
the RESTORE_POINTERS command is correct... Therefore a couple of 
questions:

1. do any devices at all use this message-pair?

2. are they ever sent apart from when accompanying the DISCONNECT / 
RESELECT?

3. if "yes" to 2 - can the RESTORE be used to "rewind" the pointer to a 
value smaller than the current?

4. Some LLDs just pretty much ignore the message. Thereby, AFAIU, they 
just assume that this is just a part of the RESELECT procedure and that 
they already have the proper context. Is it sufficient?

>From which I'm trying to derive whether the handling in tmscsim is 
correct, and, if not, how to correct it...

Thanks
Guennadi
---
Guennadi Liakhovetski
