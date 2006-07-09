From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] proper prototype for drivers/scsi/arcmsr/arcmsr_attr.c:arcmsr_free_sysfs_attr()
Date: Sun, 9 Jul 2006 16:28:56 +0200
Message-ID: <20060709142856.GI13938@stusta.de>
References: <20060709021106.9310d4d1.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:64525 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932456AbWGIO25 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 10:28:57 -0400
Content-Disposition: inline
In-Reply-To: <20060709021106.9310d4d1.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Erich Chen <erich@areca.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jul 09, 2006 at 02:11:06AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.17-mm6:
>...
> +areca-raid-linux-scsi-driver-update7.patch
>...
>  Update drivers-scsi-arcmsr-cleanups.patch
>...

<--  snip  -->

=2E..
  CC      drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c: In function =E2=80=98arcmsr_remove=E2=
=80=99:
drivers/scsi/arcmsr/arcmsr_hba.c:410: error: implicit declaration of fu=
nction =E2=80=98arcmsr_free_sysfs_attr=E2=80=99

<--  snip  -->

Let's add a proper prototype for arcmsr_free_sysfs_attr().

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.18-rc1-mm1-full/drivers/scsi/arcmsr/arcmsr.h.old	2006-07-=
09 12:29:42.000000000 +0200
+++ linux-2.6.18-rc1-mm1-full/drivers/scsi/arcmsr/arcmsr.h	2006-07-09 1=
2:33:29.000000000 +0200
@@ -468,3 +468,5 @@
 extern void arcmsr_post_Qbuffer(struct AdapterControlBlock *acb);
 extern struct class_device_attribute *arcmsr_host_attrs[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb);
+void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
+

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
