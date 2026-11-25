Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623656;
	b=SUGen2wZceqEKzKVmPKM5x0fCqiqJmVuicv/8A5d+mFHzhw+nkFre8sQyfWQcMYxJXam
	 S4XGZgsyAeuy2M7zLZXTzHH6Ch2VyG6l/nvpx7keqhzpNrYCvC9unV9OEsZSI+K24xCE2
	 A0k7Y855oMj5NQvbo4PhbyB0XqYbkx068R0hOXERWXgAg1SriqAnN5E42o3GSJm3GNPdv
	 I9heWm0CuW4Xs5tIwjM1wCbusYxJYwcF58yndrGCO6cr0ajw961pKFr6taB2cNsgedUbA
	 T/3xy0ctQWjisRkNw18qMm3VMMrS70c6QDANjCElDEGFoZPPBX/C8F2OZgUQjveb3pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623656;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=MFjp1Epxvbzt1A9g4t7Y/jDE3CxQAavGU4RMdlNgNPA=;
	b=gJUP6Y3aI1R3Cfii1OHn1t2hp4JPCaxEM8U+ksfg8JEZsbr9VLissd/vAd/xVPd2AX0t
	 8fB6DhXsPbXruvMkuixYnH8m0mklObMgw32BU82IWjXJHKb/2fb5fb29Lh4k1jrCj5oEi
	 sley+i8xHKgYfT+grgHbACf0ob6NFe4mpO1y4lUa4qtGozO3bVBLxnoiwJwChvJKjqR+o
	 VLPJHigu9nfbNqpxCUub49H4tD97Y/3UmBg5t7MGfuNFnrGjYK/QAoB1UosfmYLeCWzDe
	 21GrSIErvkHgGWrJ/lLSckodoTWeu9eCFZ8wU2ZhgjexDg9Z5/aKX9s4udOJRQGvoMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="Au1x/Qfi";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC034606A32A;
	Wed, 25 Nov 2026 16:20:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC034606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Au1x/Qfi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MFjp1Epxvbzt1A9g4t7Y/jDE3CxQAavGU4RMdlNgNPA=; b=Au1x/Qfixdt8Oeg5ELWQmTzZ7d
	wr1MiZso849kQQI90RjKYgtWlHvOsL4sUODQa+yJU/QJtei3+nwrCl8XPzyxSYVWxD0jEkv9ZHfHG
	OmNUZEcDaNBk4Nn1E9cP7BuRGcZNEM6J6xtS4Ket7/m79g97o7hU8kn2wKyFBLeu8gwPpXcQdviQ+
	Hln2JCas14QUSmhfJsWIjqhstDco/PUWJlhmY/+248fQXkeCIGO5O9nEwcb7Q1W2v+0HrcyzdyrIT
	XwITUgiGSX5J7ehQY0B1lclNs46kSXv1DsiPlzDA2AP0RSCXykcJrKqmOyVKoOLO8j21CyIPiZYaT
	T4+/q8fw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWFjN-00000000vNZ-3XTu;
	Wed, 25 Nov 2026 13:20:25 -0300
Message-ID: <9afd33b0951849b9a48c5a0783d76fde@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, David
 Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-mm@kvack.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, linux-sound@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, linux-block@vger.kernel.org, Marcel Holtmann
 <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowangio@gmail.com>,
 David Heidelberg <david@ixit.cz>, oe-linux-nfc@lists.linux.dev, Chas
 Williams <3chas3@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, Miquel Raynal
 <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, Vignesh
 Raghavendra <vigneshr@ti.com>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>, Eugenio
 =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Sean Christopherson
 <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
 <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, Florian
 Fainelli <florian.fainelli@broadcom.com>, Broadcom internal kernel review
 list <bcm-kernel-feedback-list@broadcom.com>, Tzung-Bi Shih
 <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 intel-gfx@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v2 10/12] docs: ioctl-number: update FS entries
In-Reply-To: <20261119053514.255348-11-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-11-rdunlap@infradead.org>
Date: Wed, 25 Nov 2026 13:20:25 -0300
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:

> Update the list of files where filesystem ioctls are defined and update
> the ranges of function numbers that are used.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: address sashiko review comment (ext4 00-2F range referred to
>     the wrong file name)

Reviewed-by: Paulo Alcantara <pc@manguebit.org>
