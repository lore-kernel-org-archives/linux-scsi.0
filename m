Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962569;
	b=Vici5HCueQrr4F+QgVBdHNY4b9jLwZ8ixJ4xtzZqKXOi92zpiG6wHD5Mhp3w/wVsMva2
	 1XBmlDkImmtUUSxtKGcFiyliKYICj7GG6kMLL3zusnd6cI8t/WeFViFck3RNMN1wDQQ6P
	 Ii6G/l3ZGsLXhKmEVivkzlAp8Vjxfvccf2wUkrtVP40ZVwRwEpihEPrSXltv77gPJ+Qcj
	 CcjB9TkXNNcPAUagdad8dKUd7NfHwYO+mvwfwK0IKPspzkzZcs+/uv6MgxZgFGAaVHbpT
	 CNCS9uA3o0sTUFIQNvrSFLOvbZCOal9FbmcNeGAhpnnx0+vNbJO4zmWldzt32J36PRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962569;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ZkGYeIrryqDq+inQbLWkmmEr1dkiBjnSvcr/8PVZk+Y=;
	b=1xD+ps1fSSUrDG5Ig4VNJNg5lWyFXTOLrgvNpWT4HyMOYsP20ISIOZ6a6oDFhAz3MG+A
	 dFzUaSihNpA3YvObE7cPCbs6fG+OLKz1z3L7Oh8lf/CiVu+EAuqOw3g8o4l04var3L6nT
	 h1qFdtc8ssfXhoIJBsQUJKDeSyPKD/NuJ3NQNwE+5CXbEoSzi/pbXEie1HLNsJ4djfxmC
	 ntyhv2CcjmPidJlelXpXS1lD8xhTTFYSv7l3DpAtl8wbFYBPtcHWPS+5deUbfc2rnMDxF
	 1EZCelK1ccdD+bHde0Q0nTUn25D/c7yNj2eE/p7EAk+MSn4VEyxuR7pjMKFQ0qTxMyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=igCqbrdM;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF04606A890;
	Wed, 18 Nov 2026 00:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AF04606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=igCqbrdM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=ZkGYeIrryqDq+inQbLWkmmEr1dkiBjnSvcr/8PVZk+Y=; b=igCqbrdMvYdH2Ll7yuVQgiWBLt
	/GjOlBhkNv3Atf058oFTC35r7J1y0Dn+izVMR4B7NTJEgzYPHyNBT/yjDLM3vKgbn4EFnLL1HvfM2
	G8HTUE2iRUo+Ako4z/l/tGbDtgdpSVnn3+sjWev4F279cv0k0FF8It0l+2omvAOvX90nrKkVMHldR
	y4SubNJLjheuSGQXijcB5uH5+COAZ+CInyJl5sc9OV63iS8Y4FJBagg/Ml+jigC5FfWN8akPbdtOp
	IW55/TtVzpAhYfHqN4Q+3n+P1FyoIpvl7F9FFouhH/iKFh+WdtjvK3wQHam39CoLFXiHmYbfepuXX
	RGWrdOyg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTTks-00000007Onb-3pzj;
	Wed, 18 Nov 2026 00:42:30 +0000
Message-ID: <8d287ebe-56cd-4429-89c7-d89c295efeca@infradead.org>
Date: Tue, 17 Nov 2026 16:42:28 -0800
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
Subject: Re: [PATCH 04/12] docs: ioctl-number: update networking entries
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
 <20261114202653.3113381-5-rdunlap@infradead.org>
 <sashiko-outbox-215804@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <sashiko-outbox-215804@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/15/26 12:27 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] docs: ioctl-number: duplicate bnep.h entry and missing conflict
>   marker
> --
> 
> commit acf95c4d46bf87ab8fab382911993f6e83864afc
> Author: Randy Dunlap <rdunlap@infradead.org>
> 
> docs: ioctl-number: update networking entries
> 
> This commit updates the networking ioctl file paths and function number
> ranges in Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> index 2b2d3fd317158..cd4f0bf6db66a 100644
>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>> @@ -132,6 +132,7 @@ Code  Seq#    Include File                                             Comments
>>  'B'   00-0F  include/linux/pmu.h                                       conflict!
>>  'B'   C0-FF  advanced bbus                                             <mailto:maassen@uni-freiburg.de>
>>  'B'   00-0F  xen/xenbus_dev.h                                          conflict!
>> +'B'   C8-D4  net/bluetooth/bnep/bnep.h                                 <mailto:linux-bluetooth@vger.kernel.org>
>>  'C'   all    linux/soundcard.h                                         conflict!
>>  'C'   00-68  sound/compress_offload.h                                  conflict!
>>  'C'   01-2F  linux/capi.h                                              conflict!
>> @@ -173,7 +174,7 @@ Code  Seq#    Include File                                             Comments
>>  'H'   FC     sound/pci/asihpi/hpios.h                                  conflict!
>>  'H'   00-0F  uapi/misc/habanalabs.h                                    conflict!
>>  'H'   A0     uapi/linux/usb/cdc-wdm.h
>> -'H'   C0-F0  net/bluetooth/hci.h                                       conflict!
>> +'H'   C0-F0  net/bluetooth/hci_sock.h                                  conflict!
>>  'H'   C0-DF  net/bluetooth/hidp/hidp.h                                 conflict!
>>  'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 conflict!
>>  'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 conflict!
> 
> [Severity: Low]
> Should the 'H' C0-DF entry for net/bluetooth/bnep/bnep.h be removed now
> that 'B' C8-D4 is added, and should the 'B' C0-FF and 'B' C8-D4 entries
> be marked with conflict!?
> 
> net/bluetooth/bnep/bnep.h only defines 'B' ioctls (BNEPCONNADD through
> BNEPGETSUPPFEAT, 200-212) and none with code 'H', while 'B' C8-D4
> overlaps with the 'B' C0-FF range for advanced bbus.

All done (whatever advanced bbus is).

-- 
~Randy

