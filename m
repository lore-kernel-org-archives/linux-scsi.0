From: "T.Krishnanand" <krishnanand.thommandra@gmail.com>
Subject: iscsi target - SCSI mid layer
Date: Thu, 8 Dec 2005 19:46:47 +0530
Message-ID: <2bd90fb70512080616k1f8c88e4mae7985d2461ccda1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.200]:34263 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932145AbVLHOQs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 09:16:48 -0500
Received: by zproxy.gmail.com with SMTP id 14so657937nzn
        for <linux-scsi@vger.kernel.org>; Thu, 08 Dec 2005 06:16:47 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In the case of a  Linux box which is being used as an iSCSI target
with SCSI disks, what are the demerits in BY-passing the SCSI
mid-layer so that the iSCSI driver directly talks to the LOW-level
SCSI drivers for the specific HBAs ? (ignore the HBA vendor lock-in
issues etc....ANY technical issues ?

Since the SCSI-midlayer's most important function of error handling
etc will anyway be performed by the equivalent entitiy on the iSCSI
initiator side....I dont see any good reason to depend on the SCSI
mid-layer at the target side.
But I'm new to this hence ... this post.

thanks,
-tkrishna
