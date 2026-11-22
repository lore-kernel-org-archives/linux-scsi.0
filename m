Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795366163;
	b=M2rVjQh+0cadtFz6iwnDh7OCO4OUXCRthieb2Oky2UfUVIRKoEJ4wo3UcNFCffaJkYUT
	 ZfswG4mEnNsEIoNibiYKxyYY0LNhZGLoVKn/eGaV3L2W0RQ2ULD0j1p8SihuYfZnVTeSX
	 KpXljjQYUGDtXN68S6Lzd8GA7ybWIbCuXDI9egEaoD66IpO/vG5J9F/bezvdm3XKxFah1
	 IjPNl+wqWB1DaMQdTyR4fMs46QdF9X95PVH24LNpJ4hchSPHeVythVrmdIrnHVV0c4mWe
	 MzVaWtH3+YzF1oHm2a33oPaRMpDTGNuK1y4FJ4bJvf9UHEoi/XtZT+9ujPhT+QfVpxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795366163;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=1n4tlVAMD1oQEfLg7AgK6BF8JkJzQIdhcOfMal/6gZY=;
	b=Xn1QeDYrhUCf5KSznSO8TQS5yilxytITKRCS0Q98TtaU1Bh2PDExizFYCKIpsHvWNcgu
	 E8XcT6vXAr/qvpqYW6UanZhXVd3nys0uknOiOkyuE1nbGg3ePnHngh/HUpTFcrppOddb+
	 czlTKIvcKQjOxOpAAww3jtr1ENgTkOAbpLuymNNNbcWpuKCoTDNENk+PuJqlRhFyFMIbO
	 8nTLbkM8WWK8O7rYMuJeMtTKHHCp+ZwZ96VXFPChH5uGlDmPU3z/vlppNM3Aajjm3tGEV
	 vDB+lc+wwmQyx1lsHZnZXAFp7qEp5VJCtD1ueBPgk9mRafCwMe+QOpjedDbWTQXMXIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=If1yj84T;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617FD606A320;
	Sun, 22 Nov 2026 16:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 617FD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=If1yj84T
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=1n4tlVAMD1oQEfLg7AgK6BF8JkJzQIdhcOfMal/6gZY=; b=If1yj84Ty+PWC5pwN3l+urBf68
	2hR0b/KbpLdHtCSDssJRGtWWNVVHcXXibwvo0e16Wu5PcF1GbzrF+0Nn/0orhZPZLp3AaUrOqCeE3
	M0g3/VZCXrSCWsLf3OJiUda66VgMdDR5zNN/JnYJhMr6Zloh8ZVpZL5T6FbjOGEGGG9pYSEFlPSo3
	xNjZ+pwXJ34Yaiph8LhnUvR+33XsPWSndNcZzF1mF1Y/Rg3p7J5onQ/FXu2y6sBr06vas2ATQ1cNu
	jo4l2Ca8g1GdoMwCPQY26/RHxrAwrwLjXqoQ1EhLUm39E6z3sHmGRuhzwWdrOJON3ct7fIVJwApAK
	GCbPEuHg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVAkg-00000001O6v-277K;
	Sun, 22 Nov 2026 16:49:19 +0000
Message-ID: <1e62d5c8-3ca7-441d-8979-f054fb815912@infradead.org>
Date: Sun, 22 Nov 2026 08:49:16 -0800
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
Subject: Re: [PATCH v2 02/12] docs: ioctl-number: update sound entries
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
 intel-xe@lists.freedesktop.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-3-rdunlap@infradead.org>
 <sashiko-outbox-224494@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-224494@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/26 9:36 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] docs: ioctl-number: incomplete sequence range for
>   sound/scarlett2.h
> --
> 
> commit 93a4f635ed001735e939a3dc4a2526e8af9e9bd0
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> docs: ioctl-number: update sound entries
> 
> This commit updates the ioctl-number documentation table with additional
> sound subsystem files and sequence number ranges.
> 
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> index e1d56d5cccd14..f29d2c17ca7b9 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> 
> [ ... ]
> 
>> @@ -204,6 +209,9 @@ Code  Seq#    Include File                                             Comments
>>  'S'   80-81  scsi/scsi_ioctl.h                                         conflict!
>>  'S'   82-FF  scsi/scsi.h                                               conflict!
>>  'S'   00-7F  sound/asequencer.h                                        conflict!
>> +'S'   20-52  sound/core/seq/seq_compat.c                               conflict!
>> +'S'   60-63  sound/scarlett2.h                                         conflict!
> 
> [Severity: Low]
> Should the sequence range for sound/scarlett2.h be 60-64?
> include/uapi/sound/scarlett2.h also defines
> SCARLETT2_IOCTL_GET_ERASE_PROGRESS with sequence number 0x64:
> 
> include/uapi/sound/scarlett2.h:
> #define SCARLETT2_IOCTL_GET_ERASE_PROGRESS \
> 	_IOR('S', 0x64, struct scarlett2_flash_segment_erase_progress)

Yes. Fixed now.

-- 
~Randy

