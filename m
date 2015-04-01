From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v1] ata: ahci_xgene: Enable native NCQ and FBS for second generation of X-Gene SoC.
Date: Wed,  1 Apr 2015 20:18:01 +0530
Message-ID: <1427899682-10912-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---

Suman Tripathi (1):
  ata: ahci_xgene: Add AHCI Support for second generation of APM X-Gene
    SoC

 drivers/ata/ahci_xgene.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--
1.8.2.1

