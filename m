From: iscsi learner <iscsilearner@gmail.com>
Subject: linux-scsi on a iSCSI target mode PCIe HBA
Date: Thu, 7 Oct 2010 11:02:00 -0700
Message-ID: <AANLkTin0ssMxhgoYssxK3z0qYhZ0Rhjay9VPz-L9piOm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0JGSCC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 14:02:02 -0400
Received: by fxm4 with SMTP id 4so93100fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2010 11:02:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi
I have a target mode iSCSI (and linux 2.6.27)   running on a PCIe HBA.
  This target mode HBA  will completely offload  iSCSI
from  storage server to  itself. Storage server will receive only SCSI
CDB (from this PCIe target HBA) and pass it to attached disk backend.

Over the PCIe interface only the  SCSI  command-response/data is  exchanged.

Experts,   please clear my doubt  about the work/design   to make it work-

I think I should  register myself as  SCSI Mid Layer LLD and  then all
the  SCSI command/data  received by target-mode-iSCSI-stack will be
available in  queuecommand interface of  SCSI Mid layer.  Is that the
right assumption and the  best approach?

In my case the LLD  will then pass that SCSI command/data across the
PCIe to storage server.   To be more clear this LLD will be running
ON a PCIe HBA

The target mode iSCSI stack can be any one of the popular linux iSCSI
target stacks.


Thanks much in advance
