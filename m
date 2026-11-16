Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789923;
	b=qLqWPv57iyDayy7LXtSsRn+XmtOBrnpDwjV42ld8lBV02gRBbksqAGqSjVND5Vx2xa7V
	 NFMciI/hKh0eqD95V/2VEv5E8+yvyn347EWhO/Aip7kBk/heJ3TZSjRQlrcObo1GrsJPx
	 +BeVud5sYggfDiTi+bvYUYSLUjhBtlxD1/ofgppL32Yv7rQh8Hhe+jJoJTrswuobvxdjq
	 7IyJ60vpC0Kzl0wCGmNSpte1WqVzHkgRil+5usMKNJULFreSXyWh7gGNpnGgpFnN/84GL
	 3IfzocYyAhDWwOFFjBP5wpN5KDoW+MX7e1dqVYivxn3eCcXqz+ojhvRvy29zy2b06nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789923;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=nEPXf1cG5J+Lghgn3UQeDfptX1Hk+zVJPSj0Zk2IzFQ=;
	b=XA8jO1bImAyQq652g+O9ysgTK9J0LNpAnQUCF6P0+KREaZyDH97zgP0cbZgKW4QBrVzh
	 0Szb5+liCTrpnniEQpam4TQzQiTdyPwgIetNUM9e4tp1kPMxcqWFH0c28PXNjacbrUwsE
	 NrEoBQbjRGB0e4L4wkn8WlGuSvRzbsDtErzZd7ZxcYyMgDPnpeiDYfljqMxAet5pOtv96
	 cLqrf0F+eYXXk0fH05px2IeetyTx8Dj1dyuHWoOJ4XWJ01Q66b8KC9SyJu8ixbF7dWKfl
	 T6WkWVOEKaypXGwxu+wOStxtQF8PEqc9/NrnbSp9BZUU3iC23HAQuZnqTYjLOkOYrFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Ov44YrtP;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A57606A31F;
	Mon, 16 Nov 2026 00:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91A57606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Ov44YrtP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=nEPXf1cG5J+Lghgn3UQeDfptX1Hk+zVJPSj0Zk2IzFQ=; b=Ov44YrtPxUC++hYRNDHSdmdpGW
	JaxLbFR1NnGayLi7FHLtyTi+He4ZYSfoC7yWmGobJ7E/AIaLAiwDiqmK+og7vdQvnP4EzvIpr462x
	EDmrhZM3u/N2SWbcqZV+o7jR7R+AN7ZLDYmWxP5FpNx3G+I1qCrQflyake80HiJ9rMKVM/x4eT782
	9JEn4jhTrQPKUH9n7ugwPApkYe7cQrElzRWPUKP8gRVT9cQSw9rpPJq9AX3iS6GqmzfQn0wqcsM7f
	leTLxbzdojuK+f/LSdN/KzQKSZ97Y6xYotP0eKRTTUizqT5t8J7W/n/cd6b1FIlVQIvCGZw4VHm9P
	KD0dlVWg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSkqM-00000000pP7-2dPd;
	Mon, 16 Nov 2026 00:45:10 +0000
Message-ID: <bbdb3140-dc5f-4ae1-a5a9-c2e25387409a@infradead.org>
Date: Sun, 15 Nov 2026 16:45:07 -0800
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
Subject: Re: [PATCH 01/12] docs: ioctl-number: update MM entries
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-mm@kvack.org, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, linux-sound@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
 oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
 linux-atm-general@lists.sourceforge.net,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 MPT-FusionLinux.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org,
 Neill Kapron <nkapron@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Hans de Goede <hansg@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Tzung-Bi Shih <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-2-rdunlap@infradead.org>
 <f37ccd71-8e1d-4dd4-b11a-e22b9e617dea@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <f37ccd71-8e1d-4dd4-b11a-e22b9e617dea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/15/26 8:58 AM, David Hildenbrand (Arm) wrote:
> On 11/14/26 21:26, Randy Dunlap wrote:
>> Add ioctl number entries for test_hmm_uapi and gup_test.
> 
> Just curious, why do we care about uapi for test interfaces that never see the
> light of day in production kernels and their sole purpose is to go a long a
> dedicated selftest?

a. We don't control who builds/runs these tests.
b. There might be some USB gadget or HID driver running at the same time
   as these tests.
c. It's preferable not to have conflicts, so any additions to this file
   should try to avoid these documented ioctls.

-- 
~Randy

