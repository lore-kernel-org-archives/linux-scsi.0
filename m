From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH] RESEND ibmmca: trivial typo fixes
Date: Wed, 13 Jul 2011 00:22:13 -0400
Message-ID: <1310530933.4444.8.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial <trivial@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Michael Lang <langa2@kph.uni-mainz.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 Documentation/scsi/ibmmca.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
index ac41a9f..03f0219 100644
--- a/Documentation/scsi/ibmmca.txt
+++ b/Documentation/scsi/ibmmca.txt
@@ -434,7 +434,7 @@
    Dec 14 1996: More improvements to the ldn mapping.  See check_devices
    for details.  Did more fiddling with the integrated SCSI detection,
    but I think it's ultimately hopeless without actually testing the
-   model of the machine.  The 56, 57, 76 and 95 (ultimedia) all have
+   model of the machine.  The 56, 57, 76 and 95 (multimedia) all have
    different integrated SCSI register configurations.  However, the 56
    and 57 are the only ones that have problems with forced detection.
    - Chris Beauregard
@@ -487,7 +487,7 @@
    1) Submitting the extra-array ldn_is_tape[] -> to the local ld[]
       device-array. 
    2) CD-ROM Audio-Play seems to work now.
-   3) When using DDS-2 (120M) DAT-Tapes, mtst shows still density-code
+   3) When using DDS-2 (120M) DAT-Tapes, must show still density-code
       0x13 for ordinary DDS (61000 BPM) instead 0x24 for DDS-2. This appears 
       also on Adaptec 2940 adaptor in a PCI-System. Therefore, I assume that 
       the problem is independent of the low-level-driver/bus-architecture.
@@ -932,7 +932,7 @@
    January 3, 2001 (v4.0a)
    1) A lot of complains after the 2.4.0-prerelease kernel came in about
       the impossibility to compile the driver as a module. This problem is
-      solved. In combination with that problem, some unprecise declaration
+      solved. In combination with that problem, some imprecise declaration
       of the function option_setup() gave some warnings during compilation.
       This is solved, too by a forward declaration in ibmmca.c.
    2) #ifdef argument concerning CONFIG_SCSI_IBMMCA is no longer needed and
-- 
1.7.4.1
