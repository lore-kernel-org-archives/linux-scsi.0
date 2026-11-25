Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587237;
	b=GsedyBM6r5ZQTKjflYELn08U3xeUOzmBDfO7XbYsBXgZpwMYrkUlcKuu7zXEKkZ9+YH6
	 BbY3CYSXxxLT0S/bcTq6DbRmNHaapsjrHlUpzVdUgXhseQ4nKJnNt5Pk2sH1OXC4LDGU8
	 iqg+RochiyS8xtNdF2p8sLIy4ImGeUsJ4yIVa2o0lHhs6NZvob1Sk0EhgEwShL6rY7qEV
	 +gwV4j/LkOP1XZFFHI0vQaUbB4YfXmOFR1dXDGcFBNUPi6EPnkvo2dr06ky5ayWcMjG9O
	 g+KAyGRCD1MkANQEQySSTxLjKMW7WVyJm9Wq2wlRlFz92FdW4oQpQD3GbJ7Y7zIoUlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587237;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FGdsEE2axqxE3BUmJt/PM8Oghp4gvSw8X/brdlry9Q8=;
	b=HQ9jjI7CIR6Q5pMdBc1L/dRt4AKAPVPvDBw/v15oADwfMkuJ6rz3t0HBigkenXf3AdEd
	 TxcYSAugTdlwp0uxbPo5ZlK9ZRnmLAdZYk60sqJiE79rgY9CNf6PfuWd/sejIa6pc+kM8
	 WOjTQTpkvIWXa1tbxQsnEXut435aLGrorPH9vVad67wm5ftNpKL4DyeZJED/Q6nufPoEO
	 hKjkZTcut8oFzvhOvTW0U7AH4Kep2efgFY043uOtROPhQo7PSShsj+gG9iQr4xw9+3b4g
	 Gh5LUvHu0Sv4zRyA1PdF4QhENfe+qZajLKROy16SbeSzReE892z50/x5grrGrQhC46w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=02nQm4Xz;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E836960A5BD0;
	Wed, 25 Nov 2026 06:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E836960A5BD0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=02nQm4Xz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FGdsEE2axqxE3BUmJt/PM8Oghp4gvSw8X/brdlry9Q8=; b=02nQm4Xz+NlL83OHWvBQDWOnX4
	deYOqw1GWMwSQG39VqTXMtfR7U4V21b0eRoU13uLwOfBj+WXf1zRpm+Z8nKC1W4T9oF5hE4ZjnHTo
	yKuOCiEEqF1t+UBdRygjpzHKzi00vG3HTUgjkKRwVztXz4aHcvWIlsDQhB1oJkpaoulX+y0A1YSlg
	SIPpZXub+VPe3ViUp2HtcbyqktD0bQMOGBPWX/yCO5KeVoP+v0LJezJBortu1gBbgRfa6y2G4WD0M
	fFibaILV5WDkHiO5Uua30BAvUlUo3/350BP1G/ebY6gNhP5VUcgGv7m2JfPY61HMLON7ajYUeGMRP
	QdN8mcFQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6GS-00000008Wvh-0dNd;
	Wed, 25 Nov 2026 06:13:56 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev,
	Chas Williams <3chas3@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org,
	Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org,
	Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
Subject: [PATCH v3 05/12] docs: ioctl-number: update video/fbdev entries
Date: Tue, 24 Nov 2026 22:13:32 -0800
Message-ID: <20261125061340.3402300-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the list of files where video or fbdev ioctls are defined and
update the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change
v3: rebase

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |   14 +++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -148,9 +148,13 @@ Code  Seq#    Include File
 'F'   20     linux/ivtvfb.h                                            conflict!
 'F'   20     linux/matroxfb.h                                          conflict!
 'F'   20     drivers/video/aty/atyfb_base.c                            conflict!
+'F'   20     arch/powerpc/include/uapi/asm/ps3fb.h                     conflict!
+'F'   00-21  arch/m68k/include/asm/fbio.h                              conflict!
+'F'   00-21  arch/sparc/include/asm/fbio.h                             conflict!
 'F'   00-0F  video/da8xx-fb.h                                          conflict!
 'F'   80-8F  linux/arcfb.h                                             conflict!
 'F'   DD     video/sstfb.h                                             conflict!
+'G'   00-02  drivers/video/fbdev/pxa3xx-gcu.h                          conflict!
 'G'   00-3F  drivers/misc/sgi-gru/grulib.h                             conflict!
 'G'   00-0F  xen/gntalloc.h, xen/gntdev.h                              conflict!
 'H'   00-7F  linux/hiddev.h                                            conflict!
@@ -186,10 +190,13 @@ Code  Seq#    Include File
 'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
 'L'   E0-FF  linux/ppdd.h                                              encrypted disk device driver
                                                                        <http://linux01.gwdg.de/~alatham/ppdd.html>
+'L'   35-38  arch/m68k/include/asm/fbio.h
+'L'   35-38  arch/sparc/include/asm/fbio.h
 'M'   all    linux/soundcard.h                                         conflict!
 'M'   01-16  mtd/mtd-abi.h                                             conflict!
       and    drivers/mtd/mtdchar.c
 'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
+'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
 'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
 'N'   00-1F  drivers/usb/scanner.h
 'N'   40-7F  uapi/linux/nvme_ioctl.h
@@ -197,6 +204,7 @@ Code  Seq#    Include File
 'N'   84-8F  uapi/linux/ntsync.h                                       NT synchronization primitives
                                                                        <mailto:wine-devel@winehq.org>
 'O'   00-06  mtd/ubi-user.h                                            UBI
+'O'   1F-3F  linux/omapfb.h
 'P'   all    linux/soundcard.h                                         conflict!
 'P'   60-6F  sound/sscape_ioctl.h                                      conflict!
 'P'   00-0F  drivers/usb/class/usblp.c                                 conflict!
@@ -294,6 +302,7 @@ Code  Seq#    Include File
 'n'   00-7F  linux/ncp_fs.h and fs/ncpfs/ioctl.c
 'n'   80-8F  uapi/linux/nilfs2_api.h                                   NILFS2
 'n'   E0-FF  linux/matroxfb.h                                          matroxfb
+'n'   F8-FA  video/sisfb.h                                             sisfb
 'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
 'o'   00-03  mtd/ubi-user.h                                            conflict! (OCFS2 and UBI overlaps)
 'o'   40-41  mtd/ubi-user.h                                            UBI
@@ -310,6 +319,7 @@ Code  Seq#    Include File
 'q'   80-FF  linux/telephony.h                                         Internet PhoneJACK, Internet LineJACK
              linux/ixjuser.h                                           <http://web.archive.org/web/%2A/http://www.quicknet.net>
 'r'   00-1F  linux/msdos_fs.h and fs/fat/dir.c
+'r'   01-06  arch/powerpc/include/uapi/asm/ps3fb.h
 's'   all    linux/cdk.h                                               conflict!
 's'   07-09  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h    conflict!
 's'   64-65  arch/sh/include/uapi/asm/sockios.h                        conflict!
@@ -425,8 +435,8 @@ Code  Seq#    Include File
 0xEC  00-01  linux/platform_data/cros_ec_chardev.h                     ChromeOS EC driver
 0xEE  00-09  uapi/linux/pfrut.h                                        Platform Firmware Runtime Update and Telemetry
 0xEF  00-0F  uapi/linux/ntfs.h                                         NTFS
-0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb (in development)
-                                                                       <mailto:thomas@winischhofer.net>
+0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb
+0xF3  00-3F  video/sisfb.h                                             <mailto:thomas@winischhofer.net>
 0xF6  all                                                              LTTng Linux Trace Toolkit Next Generation
                                                                        <mailto:mathieu.desnoyers@efficios.com>
 0xF8  all    arch/x86/include/uapi/asm/amd_hsmp.h                      AMD HSMP EPYC system management interface driver
