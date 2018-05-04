From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v5 2/6] firmware: use () to terminate kernel-doc function names
Date: Fri,  4 May 2018 10:43:51 -0700
Message-ID: <20180504174356.13227-3-mcgrof@kernel.org>
References: <20180504174356.13227-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504174356.13227-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, bjorn.andersson@linaro.org, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.net, maco@android.com, arve@android.com, tkjos@android.comlinux
List-Id: linux-scsi@vger.kernel.org

From: Andres Rodriguez <andresx7@gmail.com>

The kernel-doc spec dictates a function name ends in ().

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/fallback.c |  8 ++++----
 drivers/base/firmware_loader/main.c     | 20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index b57a7b3b4122..529f7013616f 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -125,7 +125,7 @@ static ssize_t timeout_show(struct class *class, struct class_attribute *attr,
 }
 
 /**
- * firmware_timeout_store - set number of seconds to wait for firmware
+ * firmware_timeout_store() - set number of seconds to wait for firmware
  * @class: device class pointer
  * @attr: device attribute pointer
  * @buf: buffer to scan for timeout value
@@ -239,7 +239,7 @@ static int map_fw_priv_pages(struct fw_priv *fw_priv)
 }
 
 /**
- * firmware_loading_store - set value in the 'loading' control file
+ * firmware_loading_store() - set value in the 'loading' control file
  * @dev: device pointer
  * @attr: device attribute pointer
  * @buf: buffer to scan for loading control value
@@ -431,7 +431,7 @@ static int fw_realloc_pages(struct fw_sysfs *fw_sysfs, int min_size)
 }
 
 /**
- * firmware_data_write - write method for firmware
+ * firmware_data_write() - write method for firmware
  * @filp: open sysfs file
  * @kobj: kobject for the device
  * @bin_attr: bin_attr structure
@@ -537,7 +537,7 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 }
 
 /**
- * fw_load_sysfs_fallback - load a firmware via the sysfs fallback mechanism
+ * fw_load_sysfs_fallback() - load a firmware via the sysfs fallback mechanism
  * @fw_sysfs: firmware sysfs information for the firmware to load
  * @opt_flags: flags of options, FW_OPT_*
  * @timeout: timeout to wait for the load
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 9919f0e6a7cc..7f2bc7e8e3c0 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -597,7 +597,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 }
 
 /**
- * request_firmware: - send firmware request and wait for it
+ * request_firmware() - send firmware request and wait for it
  * @firmware_p: pointer to firmware image
  * @name: name of firmware file
  * @device: device for which firmware is being loaded
@@ -657,7 +657,7 @@ int request_firmware_direct(const struct firmware **firmware_p,
 EXPORT_SYMBOL_GPL(request_firmware_direct);
 
 /**
- * firmware_request_cache: - cache firmware for suspend so resume can use it
+ * firmware_request_cache() - cache firmware for suspend so resume can use it
  * @name: name of firmware file
  * @device: device for which firmware should be cached for
  *
@@ -681,7 +681,7 @@ int firmware_request_cache(struct device *device, const char *name)
 EXPORT_SYMBOL_GPL(firmware_request_cache);
 
 /**
- * request_firmware_into_buf - load firmware into a previously allocated buffer
+ * request_firmware_into_buf() - load firmware into a previously allocated buffer
  * @firmware_p: pointer to firmware image
  * @name: name of firmware file
  * @device: device for which firmware is being loaded and DMA region allocated
@@ -713,7 +713,7 @@ request_firmware_into_buf(const struct firmware **firmware_p, const char *name,
 EXPORT_SYMBOL(request_firmware_into_buf);
 
 /**
- * release_firmware: - release the resource associated with a firmware image
+ * release_firmware() - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
 void release_firmware(const struct firmware *fw)
@@ -755,7 +755,7 @@ static void request_firmware_work_func(struct work_struct *work)
 }
 
 /**
- * request_firmware_nowait - asynchronous version of request_firmware
+ * request_firmware_nowait() - asynchronous version of request_firmware
  * @module: module requesting the firmware
  * @uevent: sends uevent to copy the firmware image if this flag
  *	is non-zero else the firmware copy must be done manually.
@@ -824,7 +824,7 @@ EXPORT_SYMBOL(request_firmware_nowait);
 static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
 
 /**
- * cache_firmware - cache one firmware image in kernel memory space
+ * cache_firmware() - cache one firmware image in kernel memory space
  * @fw_name: the firmware image name
  *
  * Cache firmware in kernel memory so that drivers can use it when
@@ -866,7 +866,7 @@ static struct fw_priv *lookup_fw_priv(const char *fw_name)
 }
 
 /**
- * uncache_firmware - remove one cached firmware image
+ * uncache_firmware() - remove one cached firmware image
  * @fw_name: the firmware image name
  *
  * Uncache one firmware image which has been cached successfully
@@ -1042,7 +1042,7 @@ static void __device_uncache_fw_images(void)
 }
 
 /**
- * device_cache_fw_images - cache devices' firmware
+ * device_cache_fw_images() - cache devices' firmware
  *
  * If one device called request_firmware or its nowait version
  * successfully before, the firmware names are recored into the
@@ -1075,7 +1075,7 @@ static void device_cache_fw_images(void)
 }
 
 /**
- * device_uncache_fw_images - uncache devices' firmware
+ * device_uncache_fw_images() - uncache devices' firmware
  *
  * uncache all firmwares which have been cached successfully
  * by device_uncache_fw_images earlier
@@ -1092,7 +1092,7 @@ static void device_uncache_fw_images_work(struct work_struct *work)
 }
 
 /**
- * device_uncache_fw_images_delay - uncache devices firmwares
+ * device_uncache_fw_images_delay() - uncache devices firmwares
  * @delay: number of milliseconds to delay uncache device firmwares
  *
  * uncache all devices's firmwares which has been cached successfully
-- 
2.17.0
