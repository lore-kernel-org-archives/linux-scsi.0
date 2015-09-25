From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 0/4] scsi: cleanup ioctl headers and provide UAPI versions
Date: Fri, 25 Sep 2015 11:27:40 +0200
Message-ID: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is v3 of the series to provide an "official" sg.h header (and
scsi_ioctl.h too, though it's basically obsolete) together with the other
userspace API definitions.  The change from v2 to v3 is that defaults
for sg.c are not exported in include/uapi/linux/sg.c.

Paolo

2.5.0
