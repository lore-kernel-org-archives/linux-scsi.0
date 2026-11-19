Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066542;
	b=BwByheFMDvaS2Cktz+MvwZbQGrGHalRVyyIU1wfloRZlRyod8TPJmodW/53J/eSoC13v
	 BCydqa1G417K6hlWXXxdNw+tvMdUzZxTfqg5s3AtioKV8YQRLbIpRRsozhHGx2LA198k3
	 astLzjElxFLn2Uy30DBUujeiT3Oq12fpBcgtMCzBqoI14dulFYSTBxEOGu+pxJ7ol+BOU
	 OHHMMitskqSSmszALgUJHtH9ZLf5HKeipwq86F+W94SwiNCX36guhk+jbFs9wyStHkt7n
	 BanlyPaq2XCsgBbCb2ausiqK96fMKPHq5gFLbvQfLYeSboAq2RayHdB9gPNgU5JigNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066542;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4HnqDLCNCiAOQ9sq1Q6ULWGj/wzn4gKYXx5Raw5Q7fU=;
	b=a/h53YNX3gyhNqOyi6KowFGn5/VJWmMnBMgKkxUJgsMmLXb+eOD4RftI9Up43kmXWFGk
	 cFxROlipol3d0G6Wqqm5JkOIynII9hVJnSilDenXTJpjX/i0UdJiTBvtC+P58jWSww4JX
	 Xzq5B4bQS4p61F5PWqPYf5mjrbcB94MI0dsCsXir83ZgcRKZ09RQi27lSbMTso5Ns1gTX
	 vj8JwmKkWry2T1Yf1VSR1OOO/yMy/MmcpocNv6KUcAeeV1ePJ+4Q5JcLMWqWZmOExoRhM
	 4IaG7dvlz6DyKOQS/+DROwsycIGaK9YvCebr0pTpgiBDP94MamP8mhIWlPKLwIULS0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=pfPcCYsQ;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9431606CC69;
	Thu, 19 Nov 2026 05:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9431606CC69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=pfPcCYsQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4HnqDLCNCiAOQ9sq1Q6ULWGj/wzn4gKYXx5Raw5Q7fU=; b=pfPcCYsQEwWHQjf5W29Fay/2Uv
	UJCzM/N8GPrKSlfa0kFLlCQSAsxwysOlDXJuf47g1kmF+Z2a4A6aqLLaImJuq+Uw0Pr+eVVIL20WJ
	0+QsE2toVIUeuAewEy/xGnT7NZ6A5Ekqo5aDPryoX6bp/PFb3d+d1wjBI+Wlyl30Pa2FKn+cnqbDv
	4+km0I/8557GlM9yhg4WcFnQT9PDGri91LWN2jFxyHexdEYpPDz1TuclUwMaVWFLOsyTLkgl2Bs2+
	gZQ+OUl6AGwuouyQ5KZhilUoxyrUBrMlpuvuiGEbOw7LPa0k+AQixDX+f23ld5jyeNVdBvzyUTiy3
	LAKnDb0w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuo9-0000000Aufu-0VZ6;
	Thu, 19 Nov 2026 05:35:41 +0000
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
Subject: [PATCH v2 08/12] docs: ioctl-number: update USB entries
Date: Wed, 18 Nov 2026 21:35:09 -0800
Message-ID: <20261119053514.255348-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
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

Update the list of files where USB ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Neill Kapron <nkapron@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -233,6 +233,9 @@ Code  Seq#    Include File
 'U'   00-EF  linux/usbdevice_fs.h
 'U'   C0-CF  drivers/bluetooth/hci_uart.h
 'U'   00     net/nfc/nci_core.h                                        conflict!
+'U'   00-0F  linux/usb/raw_gadget.h                                    conflict!
+'U'   01     linux/usb/g_uvc.h                                         conflict!
+'U'   64     drivers/usb/misc/usbtest.c                                conflict!
 'V'   all    linux/vt.h                                                conflict!
 'V'   all    linux/videodev2.h                                         conflict!
 'V'   C0     linux/ivtvfb.h                                            conflict!
@@ -279,6 +282,9 @@ Code  Seq#    Include File
 'g'   20-2F  linux/usb/g_printer.h
 'g'   01-0F  mm/gup_test.h                                             conflict!
                                                                        <mailto:linux-mm@kvack.org>
+'g'   01-03  linux/usb/functionfs.h                                    conflict!
+      80-86
+'g'   41-42  linux/usb/g_hid.h
 'h'   00-7F                                                            conflict! Charon filesystem
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!
