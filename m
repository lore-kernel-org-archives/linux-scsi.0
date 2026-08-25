Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1160E3EFFCE;
	Tue, 25 Aug 2026 09:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787650145; cv=none; b=NCvPkDGRza6rpPJTZSHEn8ZD8YU04svHpBhovphk3leRHc9tc12XYSlLrzWrBmR/B/QqeFsmPYV/+nTO3o5da/QDDBvS3Lq2RkTHtAg/wVXMAcrE78QxRM/KP3OH7QB8Ph7iJa4HanNarviXIV+fpEvsN4RlEaKfcenwlYHMCsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787650145; c=relaxed/simple;
	bh=hG6Rbzda8WXlPRWyN5r0uEX/2Nv+pjxijtW22TU0hHk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=IwMnIoCxq6tbE+hRsAu3KyNf/khhuE6BtRlZI3q6F9/i4nt2ypIBbOYhsnP8RMqrPcek4KqlwjsicjSJoruLokDplOhy8J1b/otJZTdG2kQs/qbQSlZTFqIjdqzA4k8BQDGzo5uawSHaw7V3miucjv0+OIqMJWbQ85EqUT0hcRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=G0dOlIOg; arc=none smtp.client-ip=203.205.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="G0dOlIOg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787650140; bh=hG6Rbzda8WXlPRWyN5r0uEX/2Nv+pjxijtW22TU0hHk=;
	h=Date:To:Cc:From:Subject;
	b=G0dOlIOgwwJ1IqrvT2M16jdnyzpw8S44RcgBkq6+1LAN+0PWOpzRaYPGxzXr3jzDX
	 iGq5G831fiLAMv0WMJiQuwhaIcRkWikVX0cZU6BX1f90Gel5cIeAnrCjRGy5NXDwMM
	 OCywxNFeqvYUnETHQv3vyVaOFpSkEnW6IG/7EkXw=
Received: from [192.168.255.10] ([111.206.96.150])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 73A870DD; Tue, 25 Aug 2026 17:28:58 +0800
X-QQ-mid: xmsmtpt1787650138t1dukefhj
Message-ID: <tencent_D0279D01CC3CA502651B79ED88B585B6780A@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJt443li83Hli383KzjAFjCosLvQe+b27zeZC5Pwv7zY7obHZwcQ
	 1t+e6pfumLCbCJY04VNvuoFko2yrvI0q/LfspLnQ/yjYLU+6wKFwwKfiYwiFuyPySvwdBEV5NMeW
	 9n+y24SJYl3XGcGvN2RwEzbaZ5uPCwKysanw//wdXE1W95aRF3dmbDl/YazQ3ObN7iQ8a7mF0LvV
	 qCgfcdES3d4kSIb9b+b7Ux4edaAg0iErxs/cjVJkcuWOrKCXUfYVkme8ap5nRZhHqHoj56qJXoiv
	 R4PRNNoHSda+hl8Gfttw+b6l2pWigLxmSrIbOhfd06G7yTSPAIhB/r0+qydVqBdPes/ioCW5LmpD
	 IDSfF4bKirXSNIMaAVB8eRLG5r86We1vrdWDWHjsalc6yL74+TPED8I9VW1QPsnb72MtbNhUesBj
	 rN/oU+D67jF/bpnGOoHPaNbmzhOvQj0HJ6dIsCnH2R+EEToDXBFn3CchT6YlH2v3WIaYVTK7St+k
	 Vv9GvmDjgZe6Gafc8y7ksxQpgzNbciirm2PLN5jB8R9dJ5ZPBMWIS7v1Js6ZVz2hv9V4T4f6BNOa
	 P9rzQUv7gIKd2Y73xpG1hsXfcGAHPjEf6sBEjZ+5ecSrvgZiDJUdH/PedPJ/jTHWCISee644zTXX
	 L7xv37dMf+PZhEB9+5EkI4s/Kk6Xw0lEPG9MWmZfkHE5SLx6yHZ6RJHMAoVILF/O7UYwK6UNOiK8
	 ueRF+i1JCLJUneYkAzU4dFbjE3z7f1chTVpSlEQdGnLi/VcIMNLGtadWQfY1hyftbRQlJyCyRJDR
	 qAicNJwO7Gk9IlpFjqgEuqb6cz8AVZIGGdNG1MmMIYvR92EOVTnh5hpPnuQYxvB/qR2qA5OpSL3S
	 XD7APND7nT7/z24pNJXQLKw2DoqQ+HQDVq3/aGAI6QQX20WPyioy1+YSsTK+HX5yndAaFmZ0LTrx
	 KI193Ob+RvJduTsG+c91RrHEx2IbDVD+Mx/nDslF1tK+UAW2Kc1H4aSOu3EwMq6kAdg8KKmwUV1k
	 iyug03Mnsuk3XizkxNS0UIuXX07TgKQJycPGgtb2tIzBfGjK6RuXnbVPGh8pZn0/r6K9wcb9Q+uE
	 jQUTGSJ0wC8GTBXC5r1S1bmFLFbg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-OQ-MSGID: <5fd57bad-49d1-4236-b424-d42030374130@qq.com>
Date: Tue, 25 Aug 2026 17:28:57 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
From: Yang Zi <2959243019@qq.com>
Subject: [PATCH] scsi: stex: Fix NULL pointer dereference in stex_hard_reset()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

stex_hard_reset() reads the PCI bridge device via hba->pdev->bus->self
and passes it to pci_read_config_byte()/pci_write_config_byte() without
checking whether it is NULL.  When the controller is attached to a root
bus (or otherwise has no bridge device), bus->self is NULL, and
pci_read_config_byte(NULL, ...) dereferences it in
pci_dev_is_disconnected(), triggering a NULL pointer dereference.

KASAN report:

    BUG: KASAN: null-ptr-deref in pci_dev_is_disconnected include/linux/pci.h:2676 [inline]
    BUG: KASAN: null-ptr-deref in pci_read_config_byte+0x23/0x90 drivers/pci/access.c:562
    Read of size 4 at addr 00000000000000c4 by task scsi_eh_6/2005

    RIP: 0010:pci_dev_is_disconnected include/linux/pci.h:2676 [inline]
    RIP: 0010:pci_read_config_byte+0x23/0x90 drivers/pci/access.c:562
    ...
    stex_hard_reset  drivers/scsi/stex.c:1322 [inline] [stex]
    stex_do_reset+0x3da6/0x6490  drivers/scsi/stex.c:1424 [stex]

Skip the secondary bus reset when there is no bridge device; the rest of
the reset sequence (config space save/restore and the PCI_COMMAND poll)
does not depend on bus->self and still runs.

Signed-off-by: Yang Zi <2959243019@qq.com>
---
 drivers/scsi/stex.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 6aeeb338633d..f1dff2cc6086 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1319,17 +1319,20 @@ static void stex_hard_reset(struct st_hba *hba)
     /* Reset secondary bus. Our controller(MU/ATU) is the only device on
        secondary bus. Consult Intel 80331/3 developer's manual for detail */
     bus = hba->pdev->bus;
-    pci_read_config_byte(bus->self, PCI_BRIDGE_CONTROL, &pci_bctl);
-    pci_bctl |= PCI_BRIDGE_CTL_BUS_RESET;
-    pci_write_config_byte(bus->self, PCI_BRIDGE_CONTROL, pci_bctl);
+    if (bus->self) {
+        pci_read_config_byte(bus->self, PCI_BRIDGE_CONTROL, &pci_bctl);
+        pci_bctl |= PCI_BRIDGE_CTL_BUS_RESET;
+        pci_write_config_byte(bus->self, PCI_BRIDGE_CONTROL, pci_bctl);
 
-    /*
-     * 1 ms may be enough for 8-port controllers. But 16-port controllers
-     * require more time to finish bus reset. Use 100 ms here for safety
-     */
-    msleep(100);
-    pci_bctl &= ~PCI_BRIDGE_CTL_BUS_RESET;
-    pci_write_config_byte(bus->self, PCI_BRIDGE_CONTROL, pci_bctl);
+        /*
+         * 1 ms may be enough for 8-port controllers. But 16-port
+         * controllers require more time to finish bus reset. Use 100 ms
+         * here for safety
+         */
+        msleep(100);
+        pci_bctl &= ~PCI_BRIDGE_CTL_BUS_RESET;
+        pci_write_config_byte(bus->self, PCI_BRIDGE_CONTROL, pci_bctl);
+    }
 
     for (i = 0; i < MU_HARD_RESET_WAIT; i++) {
         pci_read_config_word(hba->pdev, PCI_COMMAND, &pci_cmd);


