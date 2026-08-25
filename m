Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1C03EEAEB;
	Tue, 25 Aug 2026 09:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649978; cv=none; b=D3giwjSUx7i3n7LtRJ9a3530T2cYqr1O61y/J0XFTfwHJnPEWzZi6K/mAo5hYJ93J+bdtAKa/YyU8YvOjEsOrXhjnplJg66NyrYsJ9VoALzNdXPK9tSyPpCPTiiwtq0sj+fmDwk6c8eZKl/qyHi/4jZf1/QtC6CdjhQTfg34YzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649978; c=relaxed/simple;
	bh=hG6Rbzda8WXlPRWyN5r0uEX/2Nv+pjxijtW22TU0hHk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FGSmvtdowf4Sw9uSwWUqwn66WY3ztTp9Qq2kCUrCdz1f2uTAwmHh3qvZOURvphltgn3E26QwQ3yRrjJQvVzqxZSKDuSIvQzH2W/JfRjRZtUwSCp+s5jspl1VVd9MSPT67F7u6lmN2c955upULvQwkQqQTKOLGZOv0AXLNB7Xaxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=v2PVwPMX; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="v2PVwPMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787649971; bh=hG6Rbzda8WXlPRWyN5r0uEX/2Nv+pjxijtW22TU0hHk=;
	h=Date:To:Cc:From:Subject;
	b=v2PVwPMXGfLkTT4sh6RcksIe7uEpPtwExqTfgsC6GNUsQ29Kp8Q9mggJxWdU+U1X+
	 Pb5ZHuv0pBoFffWyK46Z5h8Oas/xGUAiDY2KTttKCBAldJoU6mJUanQfjAInVYVbAN
	 trDFpmKbPLHeQiL18MIcAZtiWnKKy03raNVpxsQQ=
Received: from [192.168.255.10] ([111.206.96.150])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 6890382F; Tue, 25 Aug 2026 17:26:09 +0800
X-QQ-mid: xmsmtpt1787649969tvinrkqe6
Message-ID: <tencent_2399D44C746A4F7691D7B8987F68ACB7D206@qq.com>
X-QQ-XMAILINFO: NT7uTz3cNku2DrDd6U1srupvRLAscJX8ywIUEa12SkdPhzQiwG/veDwhpSlqOx
	 eLkl1t5kU0nlc2n/pun3r9AdexqvOjSLliNj1VXGdwd8xAiMzqtveYSgi0NhxyqFT1t5ZRbxMEOX
	 ncNKPRazKjwO24lp9KfToRasaSLdcneKbb6X7ikzudlOhPGpjA6ueZpWqxMSVz4d4fvSzmsWbZ0O
	 7/HSe/XaL0XhWuF8sY2grMbLS10108MVapR2BbbH7BWCg+VzJUIo38C3NPXSPDqlRlKZWy1pM3Dn
	 RdyBiCfLtwqC8jLXs+P7Lgi3L/ffO6OYVmaAv35uybbkPfFdO2LWUOEYh3jypvfRP1fEsI4vL8uH
	 XhpYBxGAFRl1aD4eU13vyggXsZ5bFt3an3Vpzugdf/7qZhcKnAb/Uev0YIma0OXzGgRxNq0ARzmm
	 JWHvgZhagOtWfQNpkjlyNTBraVbTCbKWbrK04/+ni+mp0OOICQfTE3xiF2MjQdF+YHGjHhV5KbRE
	 puQCH/uFUYWrmPkZbR+t1LlXOD9nnz7j1h9JMHUFHTshfyHIoEq3X939bEGZZVIvManDszkIzQKU
	 3hNBnRQQ0owQdZtl82AG6fCtLcukbEOjfKiECkwb+svpIQInie7CiqukyIJOiDzBWRni2sOMwX8U
	 Ij+HWNo+ZMHvtIIQN34tMdWL1S+pKGyJgMueybmnb27UpxdPXVgpkzJoyJcl8LvM59b84DCIt4ru
	 pOaoy3RwmcWgo/3ADwxg0LoEQy3nAKBHN6MkTKQVWJb+tTsnPBz3W4/Vqk4mw3OEFqH7A/xrIPgp
	 5CEkqWbJ7N0JEiVZmjHkQ4w8nZSTNnvKHa8C7mimZvW3yd9qtYdIE9jQBTeLcBG2XWgRyeIShSi+
	 L2M8AmFH++BC+WAc04mQJiHsg+9ePKkystJcYEZs6fiJ4VvpG4BoIN5fj3VqJcqbWLsbm3ggKDJN
	 IESdt7KS/5YLCtfSywgtOsODNoS4mktoDzwHqva9V9Z/iWHh5OAPGl1Q0oxDsHkEpksmieIr7Hdg
	 ABTPIk9+te0424zFzkJUJiOso3bO+hAJhU/scVHDNjPXmvm2sElgj/Y6h7JisXAyfpJq+f5oLj3B
	 ZvYgTN
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-OQ-MSGID: <05c2cb1d-794a-451b-be8b-dc1149f0a2c5@qq.com>
Date: Tue, 25 Aug 2026 17:26:08 +0800
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

