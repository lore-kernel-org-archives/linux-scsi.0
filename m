From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/5] target/tcm_fc: Misc. fixups
Date: Fri,  4 Apr 2014 16:54:10 -0700
Message-ID: <1396655655-31060-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

Hi nab and fcoe developers,

In fixing the other issue I just posted a patch for, I found some other
things in the tcm_fc fabric that could be improved. Please take a look?

Thanks! -- Regards -- Andy

Andy Grover (5):
  target/tcm_fc: Don't export ft_lport_list
  target/tcm_fc: Limit to 1 TPG per wwn
  target/tcm_fc: Rename structs and list members for clarity
  target/tcm_fc: Rename ft_{add,del}_lport to {add,del}_wwn
  target/tcm_fc: Rename ft_tport_create to ft_tport_get

 drivers/target/tcm_fc/tcm_fc.h   | 12 +++----
 drivers/target/tcm_fc/tfc_conf.c | 75 ++++++++++++++++++++--------------------
 drivers/target/tcm_fc/tfc_sess.c |  6 ++--
 3 files changed, 46 insertions(+), 47 deletions(-)

-- 
1.9.0
