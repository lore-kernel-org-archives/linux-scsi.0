From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 1/4] scsi: remove old-style type names from sg.h
Date: Fri, 25 Sep 2015 11:27:41 +0200
Message-ID: <1443173264-4105-2-git-send-email-pbonzini@redhat.com>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These will not be exported by the new linux/sg.h header, and scsi/sg.h will
not have any user API after linux/sg.h is created.  Since they have no
user in the kernel, they can be zapped.

Cc: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/scsi/sg.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 3afec7032448..370c78c37926 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -207,12 +207,6 @@ typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 
 #define SG_BIG_BUFF SG_DEF_RESERVED_SIZE    /* for backward compatibility */
 
-/* Alternate style type names, "..._t" variants preferred */
-typedef struct sg_io_hdr Sg_io_hdr;
-typedef struct sg_io_vec Sg_io_vec;
-typedef struct sg_scsi_id Sg_scsi_id;
-typedef struct sg_req_info Sg_req_info;
-
 
 /* vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv */
 /*   The older SG interface based on the 'sg_header' structure follows.   */
-- 
2.5.0
