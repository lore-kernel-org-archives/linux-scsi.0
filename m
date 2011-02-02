From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/8]drivers:scsi:megaraid.c change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:05:59 -0800
Message-ID: <1296623159-5193-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org
Cc: megaraidlinux@lsi.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/megaraid.c                   |    4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9aa0485..c212694 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1412,7 +1412,7 @@ megaraid_isr_memmapped(int irq, void *devp)
  * @nstatus - number of completed commands
  * @status - status of the last command completed
  *
- * Complete the comamnds and call the scsi mid-layer callback hooks.
+ * Complete the commands and call the scsi mid-layer callback hooks.
  */
 static void
 mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
@@ -4296,7 +4296,7 @@ mega_support_cluster(adapter_t *adapter)
  * @adapter - pointer to our soft state
  * @dma_handle - DMA address of the buffer
  *
- * Issue internal comamnds while interrupts are available.
+ * Issue internal commands while interrupts are available.
  * We only issue direct mailbox commands from within the driver. ioctl()
  * interface using these routines can issue passthru commands.
  */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5d6d07b..a18ba43 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -877,7 +877,7 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
  * @instance:				Adapter soft state
  * @cmd_to_abort:			Previously issued cmd to be aborted
  *
- * MFI firmware can abort previously issued AEN comamnd (automatic event
+ * MFI firmware can abort previously issued AEN command (automatic event
  * notification). The megasas_issue_blocked_abort_cmd() issues such abort
  * cmd and waits for return status.
  * Max wait time is MEGASAS_INTERNAL_CMD_WAIT_TIME secs
-- 
1.6.5.GIT
