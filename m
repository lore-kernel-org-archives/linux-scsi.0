Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962991;
	b=jKZgI7Q5Azf/bMMuCsIiwwo4NEFMzsnh7HVoEB2Gyckc4Yh132O+ylqxGcCjJW3qkUfj
	 7vH0A9zx5UT+NSCpdlOzxTHTe7RSzjEVWqSF4wC7ypsAkVotbzb/qNdDsnfQ/1cFAgRcI
	 F4tglxHz7Cw5/gfgk0qFn1gBJmdI5yuXfC+EeBGwDY/oNXBaY1SU1TgPjFjKwIr8aNRDw
	 MQT6RnGVRZnqr5QXvNaffYrWwL4mxMbFK+OLERjlR6P1h00/DXXn1koljBrE8zotdXN38
	 XrtUYHrFX6DbVwyh95ofWMGDOhrc4m24rjfg3i8NEeWXwt9IH6x7fcXe4miu65qr8Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962991;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=X1mRNb9No3wdnTR/cMHZKezqf8q53Bzdh8b1/a21plE=;
	b=nx+rfpjYWv+++aRxQ1QVE7oXe02/GJjdcwVvj0jROREs2EnEyJ95N6rllXeBxTyq7HW4
	 5+2Mm4A5HWy3VNKr/+2BvM8+1roxv4B6C/Mw8dyAAqULDPNq8hJLou7uAHgwjYpJGZmq/
	 Ean5IhH0yvPGxWpQHtMbWkxBRT3inoWqdAAfsFnEk6KZ185E3JRma8bORjKd9AfFSpGWW
	 EhMrxRA7EEEFgAK3gZcY7NmwhWSBOy+1RF+/ROfei5bvZftF3w26KRJVLD9vQ4wW44NzM
	 tWNDgtCLEK049gF5s2bGoWD1JBFl37U+GHIfYzzQIpE8zuGCzkoGRCeb4KdYvpjQlUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dv+UlE7D;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8701D606A31C;
	Wed, 18 Nov 2026 00:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8701D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dv+UlE7D
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=X1mRNb9No3wdnTR/cMHZKezqf8q53Bzdh8b1/a21plE=; b=dv+UlE7D0vybkp2FFYzNVNv6tm
	zuETQaw8E6xBRIiGf3XrdmMTGCImEG/hGKGwMuJ7CT58L6L1y6BHWR1FYaQve6JaIFsv0ISM2sMJx
	8jAWIyB13E0JYfbhkuwbqpTPS9B2dOpD2JlFRWg8y9c1FQiQhBb4rKxPs1Hgycu2lCiv7O43j4UPS
	7RA3u1p6jp7RnjHRo7iObXjiXdgaou2K+XNoFnLv/G+NOYOowQFgY7dqYq1ReDt5U2TnxKsVY+WD0
	8/o+99/RZuj1sQMk2r3zRJ/Xp4lmlrEtBAp5LKX9JOjA2VYJlOnSYRluHFMJFWl7bKg/+hNKg3ahe
	3rwqX+mw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTTrj-00000007PFp-2tTG;
	Wed, 18 Nov 2026 00:49:35 +0000
Message-ID: <aab3bd74-80c6-4d51-a433-140b1d27946e@infradead.org>
Date: Tue, 17 Nov 2026 16:49:32 -0800
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
Subject: Re: [PATCH 10/12] docs: ioctl-number: update FS entries
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
 <20261114202653.3113381-11-rdunlap@infradead.org>
 <sashiko-outbox-215810@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-215810@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/15/26 12:27 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] docs: ioctl-number: ext4 00-2F ioctl range points to
>   fs/ext4/ext4.h instead of uapi/linux/ext4.h
> --
> 
> commit 9072a8199d2be085dc5ab2567392180faf810c6d
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> docs: ioctl-number: update FS entries
> 
> This commit updates the header file paths and sequence number ranges for
> filesystem ioctls in Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> index 87e547be9e2ac..abc89b6288ba3 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> 
> [ ... ]
> 
>> @@ -275,7 +276,7 @@ Code  Seq#    Include File                                             Comments
>>  'f'   00-1F  linux/ext2_fs.h                                           conflict!
>>  'f'   00-1F  linux/ext3_fs.h                                           conflict!
>>  'f'   00-0F  fs/jfs/jfs_dinode.h                                       conflict!
>> -'f'   00-0F  fs/ext4/ext4.h                                            conflict!
>> +'f'   00-2F  fs/ext4/ext4.h                                            conflict!
> 
> [Severity: Low]
> Should this entry point to uapi/linux/ext4.h (or both headers) instead of
> only fs/ext4/ext4.h?
> 
> Commit 519fe1bae7e2 ("ext4: Add a uapi header for ext4 userspace APIs")
> moved the EXT4_IOC_* definitions spanning 0x03 through 0x2E into
> include/uapi/linux/ext4.h, leaving only the compat EXT4_IOC32_* definitions
> (0x03 through 0x08) in fs/ext4/ext4.h.

Done.

-- 
~Randy

