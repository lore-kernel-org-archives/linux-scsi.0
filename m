From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 0/4] scsi: cleanup ioctl headers and provide UAPI versions
Date: Thu, 17 Sep 2015 15:42:14 +0200
Message-ID: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34086 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbIQNma (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 09:42:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

This is v2 of the series I sent a few days ago.  A bit heavier on
the cleanups:

- export the structs for obsolete SCSI_IOCTL_SEND_COMMAND in
  uapi/linux/scsi_ioctl.h

- reduce the kernel's scsi/scsi_ioctl.h even more

- remove obsolete types from uapi/linux/sg.h

- place all obsolete ioctls in uapi/linux/scsi_ioctl.h, even those
  formerly in scsi/scsi.h [requested by hch]

... and reverting to the flat uapi/linux/ structure instead of
creating uapi/linux/scsi/.

Paolo

Paolo Bonzini (4):
  scsi: remove old-style type names from sg.h
  scsi: cleanup scsi/scsi_ioctl.h
  scsi: move all obsolete ioctls to scsi_ioctl.h
  scsi: provide UAPI version of scsi/sg.h and scsi/scsi_ioctl.h

 include/scsi/scsi.h                       |  20 +--
 include/scsi/scsi_ioctl.h                 |  38 +----
 include/scsi/sg.h                         | 266 +-----------------------------
 include/uapi/linux/Kbuild                 |   2 +
 include/{scsi => uapi/linux}/scsi_ioctl.h |  41 +++--
 include/{scsi => uapi/linux}/sg.h         |  26 +--
 6 files changed, 38 insertions(+), 355 deletions(-)
 copy include/{scsi => uapi/linux}/scsi_ioctl.h (51%)
 copy include/{scsi => uapi/linux}/sg.h (95%)

-- 
2.5.0

