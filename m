Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794688036;
	b=NPqChFHU0CFXS2Xj4lj8AJWDF7NnS5c4YH6w4JONeaSlN2fhdTwspOqtTdSKJjLl6/OC
	 0VVTygOXzCE1qyVuQKZNpLH54pM5fJnVofPo54FsNeoF0aGNJBg2kUoudi0mz2gVhg8Cc
	 aw8PukuYgQjJSQ+OcFWOO/xZvfLzrM3ZB39T7IVKh3f2K6e3EWjokuK8QFWJvn4qhw5lm
	 nfyeE8yuNPIO2pM7xVODTHISXgoFc/zR34aBHIUG8u9tKAQiaaQU+TQw6Q3rRBh9HaEY+
	 Eeh/XsiAk4+l+uff6NsMFSe9kfpuRl1Ea3OqQ2mowUVUSCkRrLN+prKSmvXkrM+75aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794688036;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+R+vnOxGbR8669a/yApMPxumePGvUCvn6pAgbhYVxac=;
	b=1LbAkG/5u3PKn5sSPZPJYOgWStqZOabRZrVgmATbtsW/YXfkfLesPyBXfyhyK0Gsw/Xe
	 Ll/GAOIEaccZke1pjCQnakuhC4TJCgc5s99gOvJPxaCWmqbJ/ckxbLdGpe9Fwohdv4nCA
	 0hK9g7+FHC6EKr5NjsjPt+5adFFI7Q5mqhLnot8DUNWKX/0jVqi3Ih/SZZ7416nSV3Cu5
	 ncn3NI1am1JYDCV6uGk6EdskgpJXMhmVxQ5LIXbZixKQ1chHRR54OzdG3Hq6Du6BItD/Q
	 tSOSkBZ7/eHmOgzE7LHoYrbz4v0gAdmhp4KO63G3ByTfnQMh4jZS8ag5n3ih8BF8GQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0gISktcF;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26A6606A333;
	Sat, 14 Nov 2026 20:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A26A6606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0gISktcF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+R+vnOxGbR8669a/yApMPxumePGvUCvn6pAgbhYVxac=; b=0gISktcFQZ2GDvifsGTgS59sfG
	kunWLZ6j4WJmZNWp5LEnszL22uc8vL2dWFu1RjmHgMxpq3+s81eoyyLyLRgh1JX2FCM+Ucnn9lnRu
	xq+ifod2xjGTYMtSqx/mjXvo6gYeG0OBVZ6us5wFR8NWjXbd6svl7TtSia805oWzbC0wdA5XmtRPu
	lz8VBaijPu8G+/iovTheAMz1DVmhcqpFoxT7ZD+ifolkPaCbDs4NZpe1KPhz7EbgIiGPKi0p7T/4P
	1yjmK74+koqPtH49egLTHRfkzHTFtjIwh9kMt2ZZP22JlvUwoK5invu82fEC7b4FzEmVSQtSLFnGI
	XhkCvv7Q==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSKL6-0000000Giga-3ShA;
	Sat, 14 Nov 2026 20:27:08 +0000
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
Subject: [PATCH 06/12] docs: ioctl-number: update SCSI entries
Date: Sat, 14 Nov 2026 12:26:44 -0800
Message-ID: <20261114202653.3113381-7-rdunlap@infradead.org>
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

Update the list of files where SCSI ioctls are defined and update the
ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -189,7 +189,7 @@ Code  Seq#    Include File
 'I'   40-4F  linux/mISDNif.h                                           conflict!
 'K'   all    linux/kd.h
 'L'   00-1F  linux/loop.h                                              conflict!
-'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
+'L'   10-21  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
 'L'   E0-FF  linux/ppdd.h                                              encrypted disk device driver
                                                                        <http://linux01.gwdg.de/~alatham/ppdd.html>
 'L'   35-38  arch/m68k/include/asm/fbio.h
@@ -260,6 +260,7 @@ Code  Seq#    Include File
 'c'   00-7F  linux/comstats.h                                          conflict!
 'c'   00-7F  linux/coda.h                                              conflict!
 'c'   00-1F  linux/chio.h                                              conflict!
+'c'   08     drivers/scsi/ch.c                                         conflict!
 'c'   80-9F  arch/s390/include/asm/chsc.h                              conflict!
 'c'   A0-AF  arch/x86/include/asm/msr.h conflict!
 'd'   00-FF  linux/char/drm/drm.h                                      conflict!
