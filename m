Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962230;
	b=Xpoczod5E7Rk+NnYa3AcIVOhXszU/sEoxhn0s1XeX3T+w3FS+K/F7euuCCW8h5ZER9iA
	 yxwe9hdrp0OBBxbSIGS81GBnO7CN/eB6ThHE2lAmto4HWmNra66A5AAKfYn31Qdz/5aH4
	 +BXeF3wRj/civ0bHXAk6VvaXbJQm57j0njXV/pWJHPe4SR9JSmuazwUaK5SCKsWUMhmNv
	 L7bFgRuFxhCrLc9zDsdJwHhGQ8bEuMoKYfK/Fyl7+o7i1cPVaFrWZYern+8kM11rNPpS4
	 kC8gDQKLnonYBOKFF5a1ZGbqJYleT1qsWT0tCRkeAk4OQZSWDhuW82GtmtkgW3x5q3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962230;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=OmzVWCZFDR+bdD7Tn9ufN+qT1kyy1LCr5wTeQGcedQ0=;
	b=dyHTa1dFKKae+2zvycP0lUOab6G3noNKenGTmhNhaul+sIiOX9Gf51DcgH6Pgs3rxMYC
	 iBDmH77wHcFX4EaJi8kCu4KnlQUCv7ee5HnBMKokweg/kf0atDANJjCydtJS0eQRMFK9G
	 +qXMS53kf8pkklaR//UoqrQWttq9zveXmoRV47vtgtZl8TZqstpl30HYCOfFPkMy2oJfv
	 BvB+flhATPqM96A3lX4XEvuSvCcPQLxVgdjM9lmZeLM59flRwqzU9QBUg2XmZnViEXVO4
	 8LgygriDLETOQvM3LnMM5D5J39c0kenB2P2RDDB8Fam1S1JazzoLYPWwE25IAuJ23YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=NQX3gFw6;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F06606A31C;
	Wed, 18 Nov 2026 00:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68F06606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=NQX3gFw6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=OmzVWCZFDR+bdD7Tn9ufN+qT1kyy1LCr5wTeQGcedQ0=; b=NQX3gFw6lRvDGC0yU8UhekA5Oy
	gFdB9ufSeWvr49UuK6RBl0r/Jkg7EEmLVXl49M1vAQmwpt4jPnwuRNUg4fH2h8EUv3+r2bfYBK+Ri
	MT3Sj71fhCK5Z8RJQv8eXlRacZYSd2tlwRiGvmip3eeMgECvucwbd4PYhOLE7fuL7fszrZVo3VcDx
	uwHTgIHvJnpG16raAq2xTMQsZV7oIgTl22DdJMeF27myk9XvpF8A+xd+gJ8H3gUv1qkWU91c745Eb
	48F7QEi5hLKC4O5f3Av2ic/qxUbKL2PeT17YmnVh2Wp8WUYXJQBrqpdMZKVhlAcf+Fied/Kv1sKDo
	dtocPIYg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTTfe-00000007NcH-2Xz4;
	Wed, 18 Nov 2026 00:37:06 +0000
Message-ID: <3fe5214e-5699-4cd6-9d5d-f529e49f4928@infradead.org>
Date: Tue, 17 Nov 2026 16:37:04 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] docs: ioctl-number: update sound entries
To: sashiko-reviews@lists.linux.dev
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
 Chas Williams <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Helge Deller <deller@gmx.de>,
 dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org,
 Neill Kapron <nkapron@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Hans de Goede <hansg@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Tzung-Bi Shih <tzungbi@kernel.org>,
 Benson Leung <bleung@chromium.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-3-rdunlap@infradead.org>
 <sashiko-outbox-215802@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-215802@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/15/26 12:27 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issues to consider:
> - [Low] docs: ioctl-number: wrong code, range, and conflict marker for
>   scarlett2.h
> - [Low] docs: ioctl-number: incomplete sequence range for sound/pcm.h
> - [Low] docs: ioctl-number: incomplete range and tab char for
>   sound/core/pcm_compat.c
> - [Low] docs: ioctl-number: incomplete sequence range for
>   sound/core/seq/seq_compat.c
> - [Low] docs: ioctl-number: missing conflict! marker on switchtec.c
>   under code 'W'
> --

All review comments correct & fixed.

-- 
~Randy

