Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266750;
	b=eNomsnEqmWblizjx6DwGugz/oe+wJl/NIOEC7q2MHVsov05TlVBv4Gg3H4Hxu1XBB7q2
	 M1vUuvTPJxMNMQ9e2THb/RJtbvaTa8SAU4CV5S/ooS6d0vpmlePPczr+c93mp9plLgwTM
	 dYpzIvGJg9TQ2mDWkgXexn3fowcMPTajjWBUVEju0xk/QYc3Z1e2oliGNFqMJVj380pwd
	 tYauST6PqRLToRoDpc7Ro2rw5ca7IV/Zot6/a1r8sPcW8PQcqJ4bgZ6r7yChByMIy7Nkh
	 JioI9LlOY2dvhAylnBaaHq5RQ18n5/bSrFrjNgnHVi9LE3VPFY4C3nLMULBPDIvVT3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266750;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=PcL3zpHa7AYugiRyyb7NpDw034Q1hpktWo6bN7DugIU=;
	b=r5NdZL6zUVdpaGDYoLxScLLrwbG1cIsozsGhw4AgaFLWFifLrJKAu/P1SMCsCs92rqwp
	 70k1mWC+zwO3waRZLx8foDVOoHUf+kFCZZ6GlA5Fe9YlJYBI6BfeOf5UiuOPKUKShHtOc
	 3d/5M2HhNRc/6KL9ubx5h4494EiBXcbFXlHp1SBRvhOXg0523FtvbYRfSf2vAO415FxNB
	 mxBRRj6y677udu2u7dhbyudwfI8uH83FvM7Zb7tlHcdzkATY10iaK5oPPtRVhv8FX/bmI
	 4Syb6skkne0PIqkyraW3OdOpjFX8sZtqLpS8yWVld7CYTO8bEcA6Qj/nUE1G1VqFJfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mnqssr4s;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1741606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 09:39:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1741606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mnqssr4s
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c414c206673so207147266b.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 02:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793266748; x=1793871548; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcL3zpHa7AYugiRyyb7NpDw034Q1hpktWo6bN7DugIU=;
        b=mnqssr4sy85sTM5I1SQd4goGVuPTJave/vSgtCX8lV15FogmRLumtMJhi20D6+gWyO
         gSVdi2qaXgwS9AX6hGIGnnK5GP44LCs+4CZ1LXaBiLq58Oytxbo71BHpNaVFxLfvYxTm
         Hg+HqCI1TOY6Suu/y35Bv9tyC8jm++8m3UffZZYDzXswrqKufX1rDVC+cLHXn0wNkqDk
         ELxdB9FEd26PkhmbtOvhorA75FFGJJzYLzQC1F3M4smLIhPEav69bn4lwQ6T8ASqeOfl
         r3zttS9HjjFUCUlWZSEZOuLmtxgu4PP4WWQ+b2w4sGcbXxE65vGclxMdXvN6kptk13jZ
         w7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793266748; x=1793871548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PcL3zpHa7AYugiRyyb7NpDw034Q1hpktWo6bN7DugIU=;
        b=h0QVCaA1Qvq5DrVT808Dui1gUG5FvBciGoTfLo6iNDVi3jsJl/oy0J+MxFqgl+cP1S
         i1mh0EtO5qWGknspyiwWesoe4Zdm2pOKjnnRlpngM7TeYCAOXoIkgrb3AlpkggIuTXFN
         HA9dD90tHlq1fEvINDjfyJa/7bFUHhX4dxOaY7SbMltXXrnYk/Hh0dZwYELX0y6PvffJ
         8oB6lGNM1M34XHQk0ySGOrGCvc02+zCoFCYjDVK5esnLaU+jzJcbpWsSpCTT+juMNB9P
         C+Vsc77QPytQJf5f4Kn5tMlrxBWKChAVKqfeY8lyTSRfmQpA+YYaPFzxxkP5ESAAaFHK
         DixA==
X-Forwarded-Encrypted: i=1; AKwUvBxuuLgl35k4eG8GY97hfhf/qelVgQo9xBdV7B+sJ8T3ReXp3WgWNePrv4YBZO/w1QTihDROHkQOqZU3@vger.kernel.org
X-Gm-Message-State: AFq9FYKWTP6ZV8J4vBA6mQ6BH/HWOtKnOPNlsnGzkkCVtmOeVk2olvSy
	GCC35HgbiSE4SUO8002JZ8R1htErQvGJZXPcnjg5UV9zHb9qNqP5yNtpbCV4xi90ZZukqs/x7NH
	lDzEqUojjou3bagx2Dg==
X-Received: from ejta22.prod.google.com ([2002:a17:906:6d56:b0:c39:4b00:1779])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d29:b0:c2e:3f49:df04 with SMTP id a640c23a62f3a-c49bdb68d6dmr420820666b.1.1793266748065;
 Thu, 29 Oct 2026 02:39:08 -0700 (PDT)
Date: Thu, 29 Oct 2026 09:39:06 +0000
In-Reply-To: <20261020164435.80499-7-djeffery@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261020164435.80499-1-djeffery@redhat.com> <20261020164435.80499-7-djeffery@redhat.com>
Message-ID: <9huzpkws977p.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH 6/9] driver core: async device shutdown infrastructure
From: tarunsahu@google.com
To: David Jeffery <djeffery@redhat.com>, driver-core@lists.linux.dev, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Stuart Hayes <stuart.w.hayes@gmail.com>, 
	Laurence Oberman <loberman@redhat.com>, Bjorn Helgaas <helgaas@kernel.org>, kexec@lists.infradead.org, 
	Ewan Milne <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>, 
	"Lombardi, Maurizio" <mlombard@redhat.com>, Bart Van Assche <bvanassche@acm.org>, 
	John Garry <john.g.garry@oracle.com>, Jeremy Allison <jallison@ciq.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Pasha Tatashin <tatashin@google.com>, 
	David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"



Incase, a device was never probed with a driver, and still part of kset
list, then it does not have shutdown call, so shutdown_one_device is
just no-op. In case this device is a child of a device marked async,
parent device keep on waiting on this device. do you think we should
optimize this case by something like this?


--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4848,13 +4848,35 @@ static bool wants_async_shutdown(struct device *dev)
  return async_shutdown_enabled && dev_async_shutdown(dev);
 }
 
+static bool device_has_shutdown(struct device *dev)
+{
+ const struct device_driver *drv = READ_ONCE(dev->driver);
+
+ return (dev->class && dev->class->shutdown_pre) ||
+       (dev->bus && dev->bus->shutdown) ||
+       (drv && drv->shutdown);
+}
+
+static void __shutdown_one_device(struct device *dev);
+static void wait_for_shutdown_dependencies(struct device *dev, bool async);
+
 static int wait_for_device_shutdown(struct device *dev, void *data)
 {
  bool async = *(bool *)data;
 
- if (!dev->p || !device_is_registered(dev))
+ if (!dev->p || !device_is_registered(dev) ||
+    completion_done(&dev->p->complete))
  return 0;
 
+ if (async && !device_has_shutdown(dev)) {
+ wait_for_shutdown_dependencies(dev, async);
+
+ device_lock(dev);
+ if (!device_has_shutdown(dev))
+ __shutdown_one_device(dev);
+ device_unlock(dev);
+ }
+
  if (async || wants_async_shutdown(dev))
  wait_for_completion(&dev->p->complete);
 
@@ -4879,7 +4901,7 @@ static void wait_for_shutdown_dependencies(struct device *dev, bool async)
 
 static void __shutdown_one_device(struct device *dev)
 {
- if (!dev->p || dev->p->dead)
+ if (!dev->p || dev->p->dead || completion_done(&dev->p->complete))
  return;
 
  /* Don't allow any more runtime suspends */

~Tarun

David Jeffery <djeffery@redhat.com> writes:

> Patterned after async suspend, allow devices to mark themselves as wanting
> to perform async shutdown. Devices using async shutdown wait only for their
> dependencies to shutdown before executing their shutdown routine.
>
> Sync shutdown devices are shut down one at a time and will only wait for an
> async shutdown device if the async device is a dependency.
>
> Enabled by default, async shutdown can be explicitly enabled or disabled
> by using the kernel parameter "core.async_shutdown=<bool>"
>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  10 ++
>  drivers/base/base.h                           |   2 +
>  drivers/base/core.c                           | 141 +++++++++++++++++-
>  include/linux/device.h                        |   2 +
>  4 files changed, 154 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..6532bd0bbfdf 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -995,6 +995,16 @@ Kernel parameters
>  			seconds. A value of 0 disables the blank timer.
>  			Defaults to 0.
>  
> +	core.async_shutdown=
> +			[KNL]
> +			Format: <bool>
> +			Enable or disable asynchronous shutdown support. When
> +			enabled, on system shutdown unrelated devices flagged
> +			as async shutdown compatible may be shut down in
> +			parallel and asynchronously. When disabled, device
> +			shutdown is performed serially and synchronously.
> +			Enabled by default.
> +
>  	coredump_filter=
>  			[KNL] Change the default value for
>  			/proc/<pid>/coredump_filter.
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index a5b7abc10ff0..40dbf588a5d6 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -103,6 +103,7 @@ struct driver_private {
>   *			   dev_err_probe() for later retrieval via debugfs
>   * @device: pointer back to the struct device that this structure is
>   *	    associated with.
> + * @complete: completion for device shutdown ordering
>   * @dead: This device is currently either in the process of or has been
>   *	  removed from the system. Any asynchronous events scheduled for this
>   *	  device should exit without taking any action.
> @@ -119,6 +120,7 @@ struct device_private {
>  	const struct device_driver *async_driver;
>  	char *deferred_probe_reason;
>  	struct device *device;
> +	struct completion complete;
>  	u8 dead:1;
>  };
>  #define to_device_private_parent(obj)	\
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 93605698affc..7fee6043dd37 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/acpi.h>
> +#include <linux/async.h>
>  #include <linux/blkdev.h>
>  #include <linux/cleanup.h>
>  #include <linux/cpufreq.h>
> @@ -37,6 +38,11 @@
>  #include "physical_location.h"
>  #include "power/power.h"
>  
> +static bool async_shutdown = true;
> +module_param(async_shutdown, bool, 0644);
> +MODULE_PARM_DESC(async_shutdown, "Enable asynchronous device shutdown support");
> +static bool async_shutdown_enabled;
> +
>  /* Device links support. */
>  static LIST_HEAD(deferred_sync);
>  static unsigned int defer_sync_state_count = 1;
> @@ -3627,6 +3633,7 @@ static int device_private_init(struct device *dev)
>  	klist_init(&dev->p->klist_children, klist_children_get,
>  		   klist_children_put);
>  	INIT_LIST_HEAD(&dev->p->deferred_probe);
> +	init_completion(&dev->p->complete);
>  	return 0;
>  }
>  
> @@ -3925,6 +3932,7 @@ bool kill_device(struct device *dev)
>  	if (dev->p->dead)
>  		return false;
>  	dev->p->dead = true;
> +	complete_all(&dev->p->complete);
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(kill_device);
> @@ -4903,6 +4911,40 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
>  	return error;
>  }
>  
> +static bool wants_async_shutdown(struct device *dev)
> +{
> +	return async_shutdown_enabled && dev_async_shutdown(dev);
> +}
> +
> +static int wait_for_device_shutdown(struct device *dev, void *data)
> +{
> +	bool async = *(bool *)data;
> +
> +	if (!dev->p || !device_is_registered(dev))
> +		return 0;
> +
> +	if (async || wants_async_shutdown(dev))
> +		wait_for_completion(&dev->p->complete);
> +
> +	return 0;
> +}
> +
> +static void wait_for_shutdown_dependencies(struct device *dev, bool async)
> +{
> +	struct device_link *link;
> +	int idx;
> +
> +	device_for_each_child(dev, &async, wait_for_device_shutdown);
> +
> +	idx = device_links_read_lock();
> +
> +	dev_for_each_link_to_consumer(link, dev)
> +		if (!device_link_flag_is_sync_state_only(link->flags))
> +			wait_for_device_shutdown(link->consumer, &async);
> +
> +	device_links_read_unlock(idx);
> +}
> +
>  static void __shutdown_one_device(struct device *dev)
>  {
>  	if (!dev->p || dev->p->dead)
> @@ -4926,6 +4968,8 @@ static void __shutdown_one_device(struct device *dev)
>  			dev_info(dev, "shutdown\n");
>  		dev->driver->shutdown(dev);
>  	}
> +
> +	complete_all(&dev->p->complete);
>  }
>  
>  static void shutdown_one_device(struct device *dev)
> @@ -4955,6 +4999,88 @@ static void shutdown_one_device(struct device *dev)
>  	put_device(dev);
>  }
>  
> +static void async_shutdown_handler(void *data, async_cookie_t cookie)
> +{
> +	struct device *dev = data;
> +
> +	wait_for_shutdown_dependencies(dev, true);
> +	shutdown_one_device(dev);
> +}
> +
> +static bool shutdown_device_async(struct device *dev)
> +{
> +	if (async_schedule_dev_nocall(async_shutdown_handler, dev))
> +		return true;
> +
> +	dev_clear_async_shutdown(dev);
> +	return false;
> +}
> +
> +
> +static void start_async_shutdown_devices(void)
> +{
> +	struct device *dev, *next, *ndev, *needs_put = NULL;
> +	bool clear_async = false;
> +
> +	if (!async_shutdown_enabled)
> +		return;
> +
> +	spin_lock(&devices_kset->list_lock);
> +restart:
> +	list_for_each_entry_safe_reverse(dev, next, &devices_kset->list,
> +					 kobj.entry) {
> +		if (wants_async_shutdown(dev)) {
> +			if (clear_async) {
> +				dev_clear_async_shutdown(dev);
> +				continue;
> +			}
> +			/* one device reference for this function */
> +			get_device(dev);
> +			/* another to pass to the async task */
> +			get_device(dev);
> +
> +			if (!list_entry_is_head(next, &devices_kset->list,
> +						kobj.entry))
> +				ndev = get_device(next);
> +			else
> +				ndev = NULL;
> +			spin_unlock(&devices_kset->list_lock);
> +
> +			if (shutdown_device_async(dev)) {
> +				spin_lock(&devices_kset->list_lock);
> +				list_del_init(&dev->kobj.entry);
> +				spin_unlock(&devices_kset->list_lock);
> +			} else {
> +				/*
> +				 * async failed, clean up extra reference
> +				 * and run shutdown from the sync shutdown loop
> +				 */
> +				clear_async = true;
> +				put_device(dev);
> +			}
> +			put_device(dev);
> +
> +			if (needs_put)
> +				put_device(needs_put);
> +			needs_put = ndev;
> +			spin_lock(&devices_kset->list_lock);
> +			/*
> +			 * If the next device has been marked dead while the
> +			 * spinlock was released, or if it has been unlinked
> +			 * from the list, it may no longer be on the
> +			 * devices_kset list. Restart the list walk to be safe.
> +			 */
> +			if (ndev && (ndev->p->dead || list_empty(&ndev->kobj.entry)))
> +				goto restart;
> +		}
> +	}
> +
> +	spin_unlock(&devices_kset->list_lock);
> +
> +	if (needs_put)
> +		put_device(needs_put);
> +}
> +
>  /**
>   * device_shutdown - call ->shutdown() on each device to shutdown.
>   */
> @@ -4968,6 +5094,14 @@ void device_shutdown(void)
>  
>  	cpufreq_suspend();
>  
> +	async_shutdown_enabled = async_shutdown;
> +
> +	/*
> +	 * Start async device threads where possible to maximize potential
> +	 * parallelism and minimize false dependency on unrelated sync devices
> +	 */
> +	start_async_shutdown_devices();
> +
>  	spin_lock(&devices_kset->list_lock);
>  	/*
>  	 * Walk the devices list backward, shutting down each in turn.
> @@ -4986,11 +5120,16 @@ void device_shutdown(void)
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
>  
> -		shutdown_one_device(dev);
> +		if (!wants_async_shutdown(dev) || !shutdown_device_async(dev)) {
> +			wait_for_shutdown_dependencies(dev, false);
> +			shutdown_one_device(dev);
> +		}
>  
>  		spin_lock(&devices_kset->list_lock);
>  	}
>  	spin_unlock(&devices_kset->list_lock);
> +
> +	async_synchronize_full();
>  }
>  
>  /*
> diff --git a/include/linux/device.h b/include/linux/device.h
> index aee79fd6b32b..1ebafa798462 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -612,6 +612,7 @@ enum struct_device_flags {
>  	DEV_FLAG_OF_NODE_REUSED = 7,
>  	DEV_FLAG_OFFLINE_DISABLED = 8,
>  	DEV_FLAG_OFFLINE = 9,
> +	DEV_FLAG_ASYNC_SHUTDOWN = 10,
>  
>  	DEV_FLAG_COUNT
>  };
> @@ -829,6 +830,7 @@ __create_dev_flag_accessors(dma_coherent, DEV_FLAG_DMA_COHERENT);
>  __create_dev_flag_accessors(of_node_reused, DEV_FLAG_OF_NODE_REUSED);
>  __create_dev_flag_accessors(offline_disabled, DEV_FLAG_OFFLINE_DISABLED);
>  __create_dev_flag_accessors(offline, DEV_FLAG_OFFLINE);
> +__create_dev_flag_accessors(async_shutdown, DEV_FLAG_ASYNC_SHUTDOWN);
>  
>  #undef __create_dev_flag_accessors
>  
> -- 
> 2.55.0
