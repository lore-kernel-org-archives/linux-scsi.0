Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794688036;
	b=DlLjCNsVP8cUvYg06TEhJ+ebIdjyVJndN5b5RmbnQs2jD1N5aA6CebORD/4rWAFEA1B4
	 w2VdKMLQcKzCd+5Pcp9X15cc/mmjIPiqZWfGscbsfWY4BI3IS4pgJEcvBZnvgVodvz6t/
	 UOEyTniN7K4DXztnfjNVD0/d0Grj13S0at/2TSZVpz/AknYWzXinrDLgs2bBFEK59rvX/
	 ON2/KnFOpfMGxuD/4QzAn27vYB5u7JOk2p/EYORxH09ZdWVyxHEY5njegmncAMix0yO4+
	 HJpC2zKrxQrH4hGtDAAgq0Yuf18/LzuZ+Ax6mmF+YSuMFss8Ub4OMAlUWWQMdpSGvrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794688036;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=g4Lr1iIWwCQDLrfv4xinJtkANuRZUZ3Hye3ay62BdDM=;
	b=yFty1+gT1h5g/lfo496+EYxklmGKKLSg2hLg4GRKlpW+DwJ9vUq/jTLj/EAUcRdoyF16
	 5f44Ue8dA66j4Pj4IGHZkB6wtYRZH5cDLGiVXmduD1Bi0MAdBkSnIPoov/z6B48g9Wi8r
	 SNz1/sMl+5fNPkB87YoKlZDDIyfzp+0MN0OaBBNQgh7FRtEUboSRGfvr3/+ZJdZ/Ga7WP
	 /HERuEXpxcGEq8ASyscI6rkNyiNTS8jAMUfJ3uAsfwRPgea9F0JopVNszGYq/9x28j7Dj
	 drlKugDNv5o0nLT9fl1eVi4i2NMB1GkwQqEasUVtkMhLgpMXeT48T8fEc3mBzQnKb6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=K+RxW3IU;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595E4606A8B9;
	Sat, 14 Nov 2026 20:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 595E4606A8B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=K+RxW3IU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=g4Lr1iIWwCQDLrfv4xinJtkANuRZUZ3Hye3ay62BdDM=; b=K+RxW3IUjPLut10UJdZN3BFbmh
	pNxgVj59+6O/xkEPsB1hqiX0K6qZJW5/M8/WqEV1J7uMnx4KuEIEFt0PDhNvNcwHr2uGYrrUYIwcE
	gtcxC7ZIsLuo69Ei00wEPYqF7uh+iWtquvhO3gwZQqnj+BOkE3qYRmomz1FB4DYyLM5e+4m7yTRmn
	VucLIkmDKfNlqGfpBae0bAvW/bzkfaOJqgckrrJ4zF1mbFGvbDxX3S9VlDpAP5qmgkUnrmxxb4L0D
	9Zo2mI2kpwS22kcR/S14ACNaGrbtHanSEoj1F3pzRF7XLKfrnQnw7bMTvvwNNW+4Bb7gQaOVbRqc7
	vcfk00zQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKLD-0000000Giga-0Wfi;
	Sat, 14 Nov 2026 20:27:15 +0000
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
Subject: [PATCH 09/12] docs: ioctl-number: update virtualization entries
Date: Sat, 14 Nov 2026 12:26:47 -0800
Message-ID: <20261114202653.3113381-10-rdunlap@infradead.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update the list of files where virtualization ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
Cc: Hans de Goede <hansg@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev

 Documentation/userspace-api/ioctl/ioctl-number.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20261113.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261113/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -200,6 +200,7 @@ Code  Seq#    Include File
 'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
 'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
 'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
+'M'   01-03  xen/interface/xen-mca.h                                   conflict!
 'N'   00-1F  drivers/usb/scanner.h
 'N'   40-7F  uapi/linux/nvme_ioctl.h
 'N'   80-83  uapi/linux/ntsync.h and uapi/linux/nvme_ioctl.h           conflict!
@@ -239,6 +240,7 @@ Code  Seq#    Include File
 'U'   64     drivers/usb/misc/usbtest.c                                conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
+'V'   00-1F  linux/vboxguest.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
 'V'   C0     linux/ivtv.h                                              conflict!
 'V'   C0     media/si4713.h                                            conflict!
@@ -357,6 +359,7 @@ Code  Seq#    Include File
 '|'   80-9F  samples/                                                  Any sample and example drivers
 0x80  00-1F  linux/fb.h
 0x81  00-1F  linux/vduse.h
+             drivers/vdpa/vdpa_user/vduse_dev.c
 0x89  00-07  asm-generic/sockios.h
 0x89  06-07  linux/sockios.h
 0x89  0B-DF  linux/sockios.h
@@ -398,8 +401,11 @@ Code  Seq#    Include File
                                                                        <mailto:kvm@vger.kernel.org>
 0xAE  40-FF  linux/kvm.h                                               Kernel-based Virtual Machine
                                                                        <mailto:kvm@vger.kernel.org>
+0xAE  C6     arch/x86/kvm/x86.c                                        X86 KVM
 0xAE  20-3F  linux/nitro_enclaves.h                                    Nitro Enclaves
 0xAF  00-1F  linux/fsl_hypervisor.h                                    Freescale hypervisor
+0xAF  00-8F  linux/vhost.h                                             conflict!
+0xAF  31-32  drivers/vhost/test.h                                      conflict!
 0xB0  all                                                              RATIO devices in development:
                                                                        <mailto:vgo@ratio.de>
 0xB1  00-1F                                                            PPPoX
