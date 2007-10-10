From: "Chris Larson" <clarson@kergoth.com>
Subject: Advice on an sg issue
Date: Wed, 10 Oct 2007 10:37:32 -0700
Message-ID: <b6ebd0a50710101037k70c5c0c1o825b7c7f0d938219@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:59817 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbXJJRhe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2007 13:37:34 -0400
Received: by el-out-1112.google.com with SMTP id v27so76432ele
        for <linux-scsi@vger.kernel.org>; Wed, 10 Oct 2007 10:37:33 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings,

I was wondering if anyone could give me advice on something.. it's
probably a quick one for anyone (unlike myself) who actually know the
subsystem :)  I'm running into an issue using sg to issue a read data
update command to a device attached to a qlogic controller.  After the
command is issued, it hangs for 20 minutes before it comes back with
an error from the write().  This behavior only occurs with a certain
firmware version of the device, so normally I'd just say it must be a
device problem... however, the git commit which switched sg.c to use
scsi_execute_async instead of scsi_do_req seems to fix the behavior.
Does anyone know, offhand, what sort of behavior change could've
resulted from switching that api use?

Thanks,
-- 
Chris Larson - clarson at kergoth dot com
Software Engineer - MontaVista - clarson at mvista dot com
Core Developer/Architect - TSLib, BitBake, OpenEmbedded, OpenZaurus
