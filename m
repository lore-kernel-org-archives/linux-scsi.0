Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587248;
	b=SIlA5fVExroXKkAR0BeUJtaKH0FyZ0L3rWTuVrSxptXE6iQK+HFeP1gIfbRo9SWIyqPe
	 C3LnHl1JunimOfGbEmEM8Fop6wMD3BvzhZS6YF3rHjJUjadR47c5eDZp/RkoXRw7iE3bL
	 mNiu79p6MIoxzPbUtrUBKLgkiiXpuawSQgsJqGP9hw9+tlhvLe1xofdxMfGRDqRBPC55t
	 jvl3+TNhPILwn10AL+vzhAuKwO8URKUhmh9PbMdJeHzZsvWdIlRCUI1lKQVxZ9LuZYayK
	 D+esXD3sj4oUB/oTkQuF9frqkDLzkwnWqdCPyJLc4++WOLlHvRQZmvoWmw/IAxoqsag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587248;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HbuCV21suICAifmMr+QiJxglk35NFZTKGTKkvkyuZyo=;
	b=ULQGKdWG9UsKSEaw7qgjSUvuefvvxbkBnYt3KNggoCkQryWSWyqCDZfQZp/7ZjvXNY0U
	 GOGyAXyioTR42KYePuZVMGbn1g75+0ZFZRxFz964lZuENdApKv/LdmqDX4leDGV4NuIMw
	 d/qC7ahWHwbSg2RTllFTrjv4mI+/GBcA+6lRBP3iYGvR2/wSqAYSyqWfyUBVfydo1fi5K
	 3lQ/QckxgIhmfIxvYEFz8fozXzCDJzAMTjAvr7c+LiP8XARZPiV8EyUyUeEgxw5QZB6uQ
	 aqpshaHOvBLbhccUPa1juwzzHxZ2tiu/XG1zoz0hx1/RsMZDQhDCTuEI65G+EoLrCBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=t0N3QvZj;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E49606D31B;
	Wed, 25 Nov 2026 06:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16E49606D31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=t0N3QvZj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HbuCV21suICAifmMr+QiJxglk35NFZTKGTKkvkyuZyo=; b=t0N3QvZj67sXAElPcQDRfFEeFC
	Ry87q/HKHnd9AflpeJ6sdyDtMOspDD6dk2kaKcGI09Doxg/kOyBkkDwuQF/GwL+aUcraRQSMAI4gq
	vaqJWlOuO16ACJ+hVxBTQvxMm6w7klhtRvz5Yuyb/9as7/epd7p8KXoZozPJ9vin16Qwnte6KAQDZ
	B28OGP5xhj8FWN6iqYyBJVLmdncGI4T/+eayqDgNpmb6Hw4RS8zBiBjrlpxInv3X7OrcCLrJYK19C
	NoN6ftlIGZXNkThIXdUqXsPtWw01Bnj1QiVeCmRzeFE66JRwhcWdPaXrSAfBriLmxjvU5NlxFqa4l
	D51u5MqA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW6Gd-00000008Wvh-05Wr;
	Wed, 25 Nov 2026 06:14:07 +0000
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
Subject: [PATCH v3 10/12] docs: ioctl-number: update FS entries
Date: Tue, 24 Nov 2026 22:13:37 -0800
Message-ID: <20261125061340.3402300-11-rdunlap@infradead.org>
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

Update the list of files where filesystem ioctls are defined and update
the ranges of function numbers that are used.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: address sashiko review comment (ext4 00-2F range referred to
    the wrong file name)
v3: rebase

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: devel@lists.orangefs.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net

 Documentation/userspace-api/ioctl/ioctl-number.rst |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-next-20261123.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261123/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -185,6 +185,7 @@ Code  Seq#    Include File
 'I'   all    linux/isdn.h                                              conflict!
 'I'   00-0F  drivers/isdn/divert/isdn_divert.h                         conflict!
 'I'   40-4F  linux/mISDNif.h                                           conflict!
+'I'   00     linux/inotify.h
 'K'   all    linux/kd.h
 'L'   00-1F  linux/loop.h                                              conflict!
 'L'   10-21  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        conflict!
@@ -274,7 +275,7 @@ Code  Seq#    Include File
 'f'   00-1F  linux/ext2_fs.h                                           conflict!
 'f'   00-1F  linux/ext3_fs.h                                           conflict!
 'f'   00-0F  fs/jfs/jfs_dinode.h                                       conflict!
-'f'   00-0F  fs/ext4/ext4.h                                            conflict!
+'f'   00-2F  fs/ext4/ext4.h, uapi/linux/ext4.h                         conflict!
 'f'   00-0F  linux/fs.h                                                conflict!
 'f'   00-0F  fs/ocfs2/ocfs2_fs.h                                       conflict!
 'f'   13-27  linux/fscrypt.h
@@ -299,6 +300,7 @@ Code  Seq#    Include File
 'k'   00-0F  linux/spi/spidev.h                                        conflict!
 'k'   00-05  video/kyro.h                                              conflict!
 'k'   10-17  linux/hsi/hsi_char.h                                      HSI character device
+'k'   01-0F  fs/orangefs/protocol.h                                    <mailto:devel@lists.orangefs.org>
 'l'   00-3F  linux/tcfs_fs.h                                           transparent cryptographic file system
                                                                        <http://web.archive.org/web/%2A/http://mikonos.dia.unisa.it/tcfs>
 'l'   40-7F  linux/udf_fs_i.h                                          in development:
@@ -372,7 +374,7 @@ Code  Seq#    Include File
 0x92  00-0F  drivers/usb/mon/mon_bin.c
 0x93  60-7F  linux/auto_fs.h
 0x94  all    fs/btrfs/ioctl.h                                          Btrfs filesystem
-             and linux/fs.h                                            some lifted to vfs/generic
+0x94  all    linux/fs.h                                                some lifted from Btrfs to vfs/generic
 0x97  00-7F  fs/ceph/ioctl.h                                           Ceph file system
 0x99  00-0F                                                            537-Addinboard driver
                                                                        <mailto:buk@buks.ipn.de>
@@ -440,7 +442,7 @@ Code  Seq#    Include File
 0xCC  00-0F  drivers/misc/ibmvmc.h                                     pseries VMC driver
 0xCD  01     linux/reiserfs_fs.h                                       Dead since 6.13
 0xCE  01-02  uapi/linux/cxl_mem.h                                      Compute Express Link Memory Devices
-0xCF  02     fs/smb/client/cifs_ioctl.h
+0xCF  01-0F  fs/smb/client/cifs_ioctl.h                                <mailto:linux-cifs@vger.kernel.org>
 0xDD  00-3F                                                            ZFCP device driver see drivers/s390/scsi/
                                                                        <mailto:aherrman@de.ibm.com>
 0xE5  00-3F  linux/fuse.h
@@ -449,6 +451,7 @@ Code  Seq#    Include File
 0xEF  00-0F  uapi/linux/ntfs.h                                         NTFS
 0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb
 0xF3  00-3F  video/sisfb.h                                             <mailto:thomas@winischhofer.net>
+0xF5  01-1F  uapi/linux/f2fs.h                                         <mailto:linux-f2fs-devel@lists.sourceforge.net>
 0xF6  all                                                              LTTng Linux Trace Toolkit Next Generation
                                                                        <mailto:mathieu.desnoyers@efficios.com>
 0xF8  all    arch/x86/include/uapi/asm/amd_hsmp.h                      AMD HSMP EPYC system management interface driver
