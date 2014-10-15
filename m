From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH net v2 0/4] ipv6 and related cleanup for cxgb4/cxgb4i
Date: Tue, 14 Oct 2014 20:07:20 -0700
Message-ID: <1413342444-16388-1-git-send-email-anish@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: davem@davemloft.net, hch@infradead.org, jbottomley@parallels.com, kxie@chelsio.com, manojmalviya@chelsio.com, hariprasad@chelsio.com, leedom@chelsio.com, swise@opengridcomputing.com, Anish Bhatt <anish@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

This patch set removes some duplicated/extraneous code from cxgb4i, guards
cxgb4 against compilation failure based on ipv6 tristate, make ipv6 related
code no longer be enabled by default irrespective of ipv6 tristate and fixes
a refcnt issue.
-Anish

v2 : Provide more detailed commit messages, make subject more concise as 
recommended by Dave Miller.

Anish Bhatt (4):
  cxgb4i : Remove duplicated CLIP handling code
  cxgb4 : Fix build failure in cxgb4 when ipv6 is disabled/not in-built
  cxgb4i : Fix -Wunused-function warning
  cxgb4i: Remove duplicate call to dst_neigh_lookup()

 drivers/net/ethernet/chelsio/Kconfig            |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  15 +++
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c              | 146 ++----------------------
 drivers/scsi/cxgbi/libcxgbi.c                   |   2 +
 4 files changed, 26 insertions(+), 139 deletions(-)

-- 
2.1.2
