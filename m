From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0002] Staging: hv: Move the storage driver out of staging
Date: Thu, 26 Jan 2012 09:37:40 -0800
Message-ID: <1327599460-12593-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Now that all the relevant maintainers have signed off on moving the Hyper-V
storage driver out of staging, this patch-set moves the driver out of staging:

	1. The first patch brings the storage driver in synch with the patches in
	   Greg's queue for the staging tree. Back on Jan 12, 2012, I had sent a 
	   patch-set to address all of Christoph's comments. Christoph has signed off
	   on these patches.

	2. The second patch moves the updated storage driver out of staging and gets rid
	   of the unnecessary files in the staging/hv/directory.

Regards,

K. Y
