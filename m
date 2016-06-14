From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [target:nvmet-configfs-ng 22/27]
 drivers/nvme/target/rdma.c:1441:1-3: WARNING: PTR_ERR_OR_ZERO can be used
Date: Tue, 14 Jun 2016 13:25:41 +0800
Message-ID: <201606141338.n0GrvsGu%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git nvmet-configfs-ng
head:   9589c853cae62cadabb17a3c48f9fdb3da5fa83c
commit: 49503f06b9b36b6c691435b25a31f6ab6c808f13 [22/27] nvmet/rdma: Convert to struct nvmet_port_binding


coccinelle warnings: (new ones prefixed by >>)

>> drivers/nvme/target/rdma.c:1441:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
