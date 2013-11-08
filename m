From: Loc Ho <lho@apm.com>
Subject: [PATCH 0/5] ata: Add APM X-Gene SATA controller support
Date: Fri,  8 Nov 2013 15:30:33 -0700
Message-ID: <1383949838-25106-1-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: tj@kernel.org, linux-scsi@vger.kernel.org
Cc: Suman Tripathi <stripathi@apm.com>, jcm@redhat.com, devicetree-discuss@lists.ozlabs.org, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Add APM X-Gene SATA controller support

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
Loc Ho (5):
  ata: Export AHCI library functions required by APM X-Gene SATA driver
  arm64: Add APM X-Gene SATA DTS binding
  ata: Add APM X-Gene SATA driver
  ata: Add APM X-Gene SATA serdes functions
  Documentation: Add documentation for APM X-Gene SATA binding

 .../devicetree/bindings/ata/apm-xgene.txt          |   84 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   73 +
 drivers/ata/Kconfig                                |    7 +
 drivers/ata/Makefile                               |    2 +
 drivers/ata/ahci.h                                 |    6 +
 drivers/ata/libahci.c                              |   13 +-
 drivers/ata/sata_xgene.c                           | 1385 ++++++++++++++
 drivers/ata/sata_xgene.h                           |  112 ++
 drivers/ata/sata_xgene_serdes.c                    | 1982 ++++++++++++++++++++
 9 files changed, 3659 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/sata_xgene.c
 create mode 100644 drivers/ata/sata_xgene.h
 create mode 100644 drivers/ata/sata_xgene_serdes.c
