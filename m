From: James Cloos <cloos@jhcloos.com>
Subject: found __[us]{8,16,32,64} type without #include <linux/types.h>
Date: Fri, 09 Sep 2011 10:22:39 -0400
Message-ID: <m3vct1u75k.fsf@jhcloos.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-mm@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-scsi@vger.kernel.org

All noticed while compiling 3.1-r5:

linux/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>

linux/usr/include/scsi/scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>

linux/usr/include/linux/mmc/ioctl.h:10: found __[us]{8,16,32,64} type without #include <linux/types.h>


-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
