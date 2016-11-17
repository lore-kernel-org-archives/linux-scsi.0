From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188061] New: On quad port QLE2564 can't add in target only 2
 ports
Date: Thu, 17 Nov 2016 23:16:43 +0000
Message-ID: <bug-188061-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751059AbcKQXQr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 18:16:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id A2BAF20411
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 23:16:45 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id A57C7203AC
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 23:16:43 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188061

            Bug ID: 188061
           Summary: On quad port QLE2564 can't add in target only 2 ports
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.8.6-201.fc24.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: anthony.bloodoff@gmail.com
        Regression: No

I have QLE2564 (quad port) with portnames:
09:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI
Express HBA (rev 02)
09:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI
Express HBA (rev 02)
0a:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI
Express HBA (rev 02)
0a:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI
Express HBA (rev 02)

systool -c fc_host -v | grep port_name
    port_name           = "0x15b0024ffaa536f"
    port_name           = "0x115b0024ffaa536f"
    port_name           = "0x215b0024ffaa536f"
    port_name           = "0x315b0024ffaa536f"
Same info from targetcli:
/qla2xxx> info 
Fabric module name: qla2xxx
ConfigFS path: /sys/kernel/config/target/qla2xxx
Allowed WWN types: naa
Allowed WWNs list: naa.215b0024ffaa536f, naa.15b0024ffaa536f,
naa.315b0024ffaa536f, naa.115b0024ffaa536f
Fabric module features: acls
Corresponding kernel module: tcm_qla2xxx

2 NAA I have succefully added:
naa.115b0024ffaa536f
naa.215b0024ffaa536f

but other two fails:
/qla2xxx> create naa.315b0024ffaa536f 
WWN not valid as: naa

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
