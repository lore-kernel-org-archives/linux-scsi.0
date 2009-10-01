From: G S <gogman69-linuxscsi@yahoo.com>
Subject: Fibre Channel pass-through for sending arbitrary FC and SCSI commands
Date: Wed, 30 Sep 2009 23:25:41 -0600
Message-ID: <da0ca6030909302225g6009092bh960a2e09f2cdeadd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f192.google.com ([209.85.211.192]:54371 "EHLO
	mail-yw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZJAFZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 01:25:38 -0400
Received: by ywh30 with SMTP id 30so7725996ywh.23
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2009 22:25:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Howdy,

The Linux "sg" (SCSI pass-through) can be used to send arbitrary SCSI
commands to SCSI target devices.

But "sg" doesn't give me access to the transport layer details, such
as constructing my own FCP_CMND and receiving FCP_RSP IU's.

Is there FC pass-thru in Linux (2.6) SCSI stack, that allows me to
construct my own transport frames and payloads?

If not, is there vendor (eg. QLogic and Emulex) provided IOCTL module
that allows application to interface directly to the HBA driver for
doing FC pass-through?

Thanks much,

G
