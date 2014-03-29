From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 20/55] scsi: Mark function as static in isci/remote_device.c
Date: Sat, 29 Mar 2014 23:35:29 +0530
Message-ID: <ba8bc6c22f1d7949f8a727dfef4262c1336b8a71.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Maciej Patelczyk <maciej.patelczyk@intel.com>, Dave Jiang <dave.jiang@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in isci/remote_device.c because it is not used
outside this file.

This eliminates the following warning in isci/remote_device.c:
drivers/scsi/isci/remote_device.c:1387:6: warning: no previous prototyp=
e for =E2=80=98isci_remote_device_wait_for_resume_from_abort=E2=80=99 [=
-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/isci/remote_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remo=
te_device.c
index 96a26f4..33033fb 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1384,7 +1384,7 @@ static bool isci_remote_device_test_resume_done(
 	return done;
 }
=20
-void isci_remote_device_wait_for_resume_from_abort(
+static void isci_remote_device_wait_for_resume_from_abort(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev)
 {
--=20
1.7.9.5
