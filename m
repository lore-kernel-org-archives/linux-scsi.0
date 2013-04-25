From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [PATCH/for-next 0/3] iscsi-target/iser-target: Fix breakage
Date: Thu, 25 Apr 2013 07:40:28 +0000
Message-ID: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Hi folks,

This series addresses two bugs within v3.10 for-next code related to
the upcoming iscsi-target series adding multi-transport support, along
with a third iser-target bugfix related to early ISCSI_OP_SCSI_CMD
exception handling.

These three patches are being folded into for-next/for-next-merge code
now..

Thanks!

--nab

Nicholas Bellinger (3):
  iscsi-target: Fix solicited NopIN handling with RDMAExtentions=No
  iscsi-target: Fix iscsit_handle_scsi_cmd() exception se_cmd leak
  iser-target: Add special case for early ISCSI_OP_SCSI_CMD exception
    handling

 drivers/infiniband/ulp/isert/ib_isert.c |    7 ++++++
 drivers/target/iscsi/iscsi_target.c     |   32 ++++++++++++++++++------------
 2 files changed, 26 insertions(+), 13 deletions(-)

-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
