Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795066526;
	b=fpd0jR0fNHXbndXQcehmfTuC6vrDhl0QXC/Q+Z9ORl8y9ESucWmBfvm+MTt/PK+L/bfS
	 9K46Z9wRrsoKGzyHDHhi/9Jg3W4pxsfqzVbRehgATFb8yhNa3cSzKl3ykFCpVZTWkHLpr
	 QJjZQNkSPzV2uq9Un0x/zH5q7+8PzG15zOixraGJ13OvhPiwAZB14BWUhoBW/SF+qOnic
	 VNthX6f9T/zwZGx72j7b4Uw29xw79uG4YhXxKAMPpcabfLFVhihoMeh9YP9zH9QmKuXtD
	 AbXVdIhvpfue5ecdi3Y7gPBZp2snnwZnNM086B3d5Waim48zfyWAH4Lr4jvGLbO9qjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795066526;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z46ZwabXBcpTEJRysA4syBAZyQggGPY6SIVcMl/gSzA=;
	b=AtnL78Xjrzq+kkrR7Es7A31LHLmD7mt5Wn08yant/TuBz8x9j3H2UkFvvnQbujrQlW2Y
	 4XWYg+zMempKB4x7ol2N37Go6+ZLpvFu5E0rvZ7Me5Q+LOQtUKvvJtI1HPiyMuwe7lJEN
	 JxxrKqFqN/AROQYKrLVwgTJfGTsXKhcGGiPziDOYtGvC9yX6pPKfH8ZZvXOVB6YMCnSrj
	 y5EgCq04i/ZNLu9PMCnhtaFJ1diUkVb1tvuzDNbAaR1ubWv/S8geEqIBi/nZU7oPEgo2a
	 gI+T66/kE9V9fxmeoEeZ0MsR/bZHTFbG7fIzLN14Il9xPq1VQCdFLCDdNM+ZMwT0yJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tZNGbQMb;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98812606A330;
	Thu, 19 Nov 2026 05:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98812606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tZNGbQMb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=z46ZwabXBcpTEJRysA4syBAZyQggGPY6SIVcMl/gSzA=; b=tZNGbQMbkEBB3qnsfmrI0ak97e
	GXxh5zYLcHrA7zzJrOQPdhV8uybDVtFAWYTrP+dt/z9kZiD41YJ2wTmXVlB8OYrmzf5wEwT37Km6a
	bsmU2r2a+szwKja0pzLZGHDqbW+LwePYyxWY28VlKJW4IkKj5u6oq7VCuB7i2yoEQ6coDe9GcyFby
	gmUkrTGRPw16swI5ikzHGUIbD/DQdgrEEfISwS/y2TJ9bAeOWAGvRZM46laKYkr4+h5q8QUSFOd1e
	FNUYp/NsoT++jUBOGEPDm/c59sWmUx3tgkmaRELHsSyXx62CAagtXJ2Elyvg7quNk77tut/ToOd3p
	hQQjF0qQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTunq-0000000Aufu-1tOB;
	Thu, 19 Nov 2026 05:35:22 +0000
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
Subject: [PATCH v2 01/12] docs: ioctl-number: update MM entries
Date: Wed, 18 Nov 2026 21:35:02 -0800
Message-ID: <20261119053514.255348-2-rdunlap@infradead.org>
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

Add ioctl number entries for test_hmm_uapi and gup_test.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: linux-mm@kvack.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20261111.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261111/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -147,6 +147,8 @@ Code  Seq#    Include File
 'G'   00-0F  xen/gntalloc.h, xen/gntdev.h                              conflict!
 'H'   00-7F  linux/hiddev.h                                            conflict!
 'H'   00-0F  linux/hidraw.h                                            conflict!
+'H'   00-0F  lib/test_hmm_uapi.h                                       conflict!
+                                                                       <mailto:linux-mm@kvack.org>
 'H'   01     linux/mei.h                                               conflict!
 'H'   02     linux/mei.h                                               conflict!
 'H'   03     linux/mei.h                                               conflict!
@@ -252,6 +254,8 @@ Code  Seq#    Include File
 'f'   81-8F  linux/fsverity.h
 'g'   00-0F  linux/usb/gadgetfs.h
 'g'   20-2F  linux/usb/g_printer.h
+'g'   01-0F  mm/gup_test.h                                             conflict!
+                                                                       <mailto:linux-mm@kvack.org>
 'h'   00-7F                                                            conflict! Charon filesystem
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!
