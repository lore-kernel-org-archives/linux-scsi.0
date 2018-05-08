From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 11/13] Documentation: fix few typos and clarifications for the firmware loader
Date: Tue,  8 May 2018 11:12:45 -0700
Message-ID: <20180508181247.19431-12-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.
List-Id: linux-scsi@vger.kernel.org

Fix a few typos, and clarify a few sentences.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 Documentation/driver-api/firmware/fallback-mechanisms.rst | 5 +++--
 Documentation/driver-api/firmware/firmware_cache.rst      | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/driver-api/firmware/fallback-mechanisms.rst b/Documentation/driver-api/firmware/fallback-mechanisms.rst
index f353783ae0be..a39323ef7d29 100644
--- a/Documentation/driver-api/firmware/fallback-mechanisms.rst
+++ b/Documentation/driver-api/firmware/fallback-mechanisms.rst
@@ -83,7 +83,7 @@ and a file upload firmware into:
   * /sys/$DEVPATH/data
 
 To upload firmware you will echo 1 onto the loading file to indicate
-you are loading firmware. You then cat the firmware into the data file,
+you are loading firmware. You then write the firmware into the data file,
 and you notify the kernel the firmware is ready by echo'ing 0 onto
 the loading file.
 
@@ -136,7 +136,8 @@ by kobject uevents. This is specially exacerbated due to the fact that most
 distributions today disable CONFIG_FW_LOADER_USER_HELPER_FALLBACK.
 
 Refer to do_firmware_uevent() for details of the kobject event variables
-setup. Variables passwdd with a kobject add event:
+setup. The variables currently passed to userspace with a "kobject add"
+event are:
 
 * FIRMWARE=firmware name
 * TIMEOUT=timeout value
diff --git a/Documentation/driver-api/firmware/firmware_cache.rst b/Documentation/driver-api/firmware/firmware_cache.rst
index 2210e5bfb332..c2e69d9c6bf1 100644
--- a/Documentation/driver-api/firmware/firmware_cache.rst
+++ b/Documentation/driver-api/firmware/firmware_cache.rst
@@ -29,8 +29,8 @@ Some implementation details about the firmware cache setup:
 * If an asynchronous call is used the firmware cache is only set up for a
   device if if the second argument (uevent) to request_firmware_nowait() is
   true. When uevent is true it requests that a kobject uevent be sent to
-  userspace for the firmware request. For details refer to the Fackback
-  mechanism documented below.
+  userspace for the firmware request through the sysfs fallback mechanism
+  if the firmware file is not found.
 
 * If the firmware cache is determined to be needed as per the above two
   criteria the firmware cache is setup by adding a devres entry for the
-- 
2.17.0
