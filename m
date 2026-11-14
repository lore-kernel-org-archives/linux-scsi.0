Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794688036;
	b=hLG+Skv53hUxTRk7MRr4u5XY8ssSbZBq3IAaVsuo58dMSpKeLg2peS6KrcjgUu+jOdJz
	 2YSGB+KQ7ISd1MdGQPVmlHZnrYwoApqAsdDJ5TaVQDmXeyR4BhDtGuFIDL3/6ECgbqZ18
	 YOw4HJCb5vgziTs3SUpOAWr4vzUWlztoW460ZlNd+1MVLqQsuYmrYyin5LOo+Ft/Lz5JH
	 8g2HdQL8TasEy2nZlrV3oWSRZM2Y9SL9OZruBAIMvFpTJ78mdwrzgr91w2TpF5zgIodrb
	 kYZBojQUiz5M6iRZydSzg9/b8ddXAhdTTtzi3eIfT9lQyRZ76LTnjDhx3qGDS+f4jXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794688036;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o+U3kWErBkCSTRLgMgKm+90EEeoH5yL29FO/FtSBNs0=;
	b=DXH6P9w7L8OYMP+NsrU+K1DyQW0KBC1tAQghn+vYaPgonURl6CK30NYTe928F7oFxc1F
	 pz8G8zt6EMiBcBUsIxGkzj+XmzNJd3LeNd04JwvuyRH4Gg83w+maLc47bUo6tWpnc0ixy
	 wsUCQI0YHreYDRZOu9An4hpTwzoPgti3Zo+9eiGpKCEF444JzuWn9cR1270QpOXx4Lxa+
	 goyj/5hehMRy1C71FjV5kpvQ3ZRD1znXDC4lGx3RO+Fw3wAmMfiXZKDcu2D7LHmgsrrH4
	 gqDZgpisUASwDcSbpFDBmq0NIIcXfElagF6oR+jgFLPU/HhtC1iyGbs4tBb3J0GHd3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="iXx/38zX";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27E8606A881;
	Sat, 14 Nov 2026 20:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A27E8606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iXx/38zX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o+U3kWErBkCSTRLgMgKm+90EEeoH5yL29FO/FtSBNs0=; b=iXx/38zXd8cg1pen5CP5P6uZUo
	wY26xN4eIACNe3VSjGGRZ+5kts2ntm/nb4UP/LSf+Y+DnX+LuBTdlRpxCeVwrl2VVi1HrxvDrCWM2
	AxlgJdBTIDiZ830SBUHp1O2RAJSNmYjoQa6PQt66wkDey10XUjavpo7CUYZ3CuDaDW4iXSmo1XJT5
	ktxRSDP9vCpP5Vz0x62H+k+pK1iRdjzL2FT7MhYxFn89V3CGB421/gqcC3IOaTl72MN6bGj+kNUjO
	E9vIoLZ6IwogEn/RA6NORrw8/7nwMUVsKblIPVDlPZ5IT0JGdDJsYOR915lSbgW00LYnSC6kfRliS
	GYoMJ4Rw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKL1-0000000Giga-2f90;
	Sat, 14 Nov 2026 20:27:03 +0000
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
	linux-atm-general@lists.sourceforge.net,
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
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
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
Subject: [PATCH 04/12] docs: ioctl-number: update networking entries
Date: Sat, 14 Nov 2026 12:26:42 -0800
Message-ID: <20261114202653.3113381-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261114202653.3113381-1-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
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

Update the list of files where networking ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: David Heidelberg <david@ixit.cz>
Cc: oe-linux-nfc@lists.linux.dev
Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |   19 +++++++----
 1 file changed, 13 insertions(+), 6 deletions(-)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -132,6 +132,7 @@ Code  Seq#    Include File
 'B'   00-0F  include/linux/pmu.h                                       conflict!
 'B'   C0-FF  advanced bbus                                             <mailto:maassen@uni-freiburg.de>
 'B'   00-0F  xen/xenbus_dev.h                                          conflict!
+'B'   C8-D4  net/bluetooth/bnep/bnep.h                                 <mailto:linux-bluetooth@vger.kernel.org>
 'C'   all    linux/soundcard.h                                         conflict!
 'C'   00-68  sound/compress_offload.h                                  conflict!
 'C'   01-2F  linux/capi.h                                              conflict!
@@ -173,7 +174,7 @@ Code  Seq#    Include File
 'H'   FC     sound/pci/asihpi/hpios.h                                  conflict!
 'H'   00-0F  uapi/misc/habanalabs.h                                    conflict!
 'H'   A0     uapi/linux/usb/cdc-wdm.h
-'H'   C0-F0  net/bluetooth/hci.h                                       conflict!
+'H'   C0-F0  net/bluetooth/hci_sock.h                                  conflict!
 'H'   C0-DF  net/bluetooth/hidp/hidp.h                                 conflict!
 'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
 'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
@@ -219,11 +220,12 @@ Code  Seq#    Include File
 'T'   all    linux/soundcard.h                                         conflict!
 'T'   00-AF  sound/asound.h                                            conflict!
 'T'   all    arch/x86/include/asm/ioctls.h                             conflict!
-'T'   C0-DF  linux/if_tun.h                                            conflict!
+'T'   C0-E3  linux/if_tun.h                                            conflict!
 'U'   all    sound/asound.h                                            conflict!
 'U'   00-CF  linux/uinput.h                                            conflict!
 'U'   00-EF  linux/usbdevice_fs.h
 'U'   C0-CF  drivers/bluetooth/hci_uart.h
+'U'   00     net/nfc/nci_core.h                                        conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
@@ -242,8 +244,8 @@ Code  Seq#    Include File
 'Z'   14-15  drivers/message/fusion/mptctl.h
 '['   00-3F  linux/usb/tmc.h                                           USB Test and Measurement Devices
                                                                        <mailto:gregkh@linuxfoundation.org>
-'a'   all    linux/atm*.h, linux/sonet.h                               ATM on linux
-                                                                       <http://lrcwww.epfl.ch/>
+'a'   all    linux/atm*.h, linux/sonet.h, linux/atmbr2684.h            ATM on linux
+             linux/atmdev.h, net/atm/ioctl.c                           <http://lrcwww.epfl.ch/>
 'b'   00-FF                                                            conflict! bit3 vme host bridge
                                                                        <mailto:natalia@nikhefk.nikhef.nl>
 'b'   00-0F  linux/dma-buf.h                                           conflict!
@@ -264,6 +266,7 @@ Code  Seq#    Include File
 'f'   00-0F  fs/ocfs2/ocfs2_fs.h                                       conflict!
 'f'   13-27  linux/fscrypt.h
 'f'   81-8F  linux/fsverity.h
+'f'   7b-7c  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h
 'g'   00-0F  linux/usb/gadgetfs.h
 'g'   20-2F  linux/usb/g_printer.h
 'g'   01-0F  mm/gup_test.h                                             conflict!
@@ -308,8 +311,11 @@ Code  Seq#    Include File
 'q'   80-FF  linux/telephony.h                                         Internet PhoneJACK, Internet LineJACK
              linux/ixjuser.h                                           <http://web.archive.org/web/%2A/http://www.quicknet.net>
 'r'   00-1F  linux/msdos_fs.h and fs/fat/dir.c
-'s'   all    linux/cdk.h
+'s'   all    linux/cdk.h                                               conflict!
+'s'   07-09  arch/{alpha,mips,sh,xtensa}/include/uapi/asm/sockios.h    conflict!
+'s'   64-65  arch/sh/include/uapi/asm/sockios.h                        conflict!
 't'   00-7F  linux/ppp-ioctl.h
+'t'   46-4D  drivers/net/ppp/ppp_generic.c
 't'   80-8F  linux/isdn_ppp.h
 't'   90-91  linux/toshiba.h                                           toshiba and toshiba_acpi SMM
 'u'   00-1F  linux/smb_fs.h                                            gone
@@ -334,7 +340,8 @@ Code  Seq#    Include File
 '|'   80-9F  samples/                                                  Any sample and example drivers
 0x80  00-1F  linux/fb.h
 0x81  00-1F  linux/vduse.h
-0x89  00-06  arch/x86/include/asm/sockios.h
+0x89  00-07  asm-generic/sockios.h
+0x89  06-07  linux/sockios.h
 0x89  0B-DF  linux/sockios.h
 0x89  E0-EF  linux/sockios.h                                           SIOCPROTOPRIVATE range
 0x89  F0-FF  linux/sockios.h                                           SIOCDEVPRIVATE range
