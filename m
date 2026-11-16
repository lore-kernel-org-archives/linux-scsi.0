Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867681;
	b=t61v6YeTAto91/DzmC09uzF4ylkH15T6ktH4UXpROQzgtCtrm/WDuxgv+lj9XRqJRSRg
	 aekHFrXxD1tRNBNYHPutZcztQL8TaUz7iAJI/XMW9MMxbbVViedUrNAnkZur+Y5FZ+/AT
	 c9Uo6lpBD11Tqx3k8e0I3IUXmdKGkWO7rI9KMr/gSbHzg4Cj9szNMUgRMAGLTvX4xAmeG
	 cygqQ76vLbAaD/AHIAQ+nIiDBiJHUFMETDyq4CclfpPzMFNyC1xwWmqYgR7DJk0ygqFrb
	 V24PnzdMKDnMgMzBUBZwxaiDZwuwJv1vj5KENDJURyKLyD5gS6mHy2K/VC9ZPXbELgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867681;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=BXL/fDhspKdov1Fv9R2cAMXBgedf/LG6cvi6/7Jo65c=;
	b=NVwdxoYAW8UUkS37HCnUpIxatbGHdyqcbWW/sL7FwdzOdOyeyuatp8K2zKIkrjLHh+Bq
	 DgcRfG6RQL3diGvGPv/xdSPALyhxspZvHGOlH8hY+Fm5+AobJbpOvvh0kT4UB8b4VdG2o
	 KPnZ5M0jKw5/gDvkuOkF627k24G/JYBmlakHRqxhV5846mH9Jszb+1mfMYjmp97LENOM8
	 84L3rH5mIVbMImEvjFrSd3CMtemKNR91YrXGNzm4d5oDaTmFAfQPT4ORu5zMYRCUWxCRL
	 SKMpAwnaDcNtjs1pzfl/euwhyDgcdKBOkxtKyIlEd18KYfHOJdWj22LXYKO5QwAe70Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=VThYQCTK;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1411E606A31C;
	Mon, 16 Nov 2026 22:21:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1411E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=VThYQCTK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=BXL/fDhspKdov1Fv9R2cAMXBgedf/LG6cvi6/7Jo65c=; b=VThYQCTK0+YExl2+ZO7Tuknnrf
	6kyowduHpBQVpfb7n1tSXedtpFNkU4jMk3jIu9Hkgh6YTzADUmrCxgKLrv9IjmY8LwM/wyAWTvTDD
	e/sSQp4UOb5tjuY3MxqRJvsxNsiNknNcq0RGaoSG8yJ8wUiQCVmAZBGlVLxfcZjyr94azpjr9IOnd
	AWdz3ni0uhKjLd3gREkk+4rC3s26NSvhlfY2UUaXgX8uIh0R2U5pwjQCQjGVYJS1A2bXWMI8l49wW
	l2fyCL1r+D2yYRXbpcd1pUH4Eqp+JWnGEwFXHp6SFfFUzbYmxjvOpOGIgf4yt8A3Gek5Rph3JughC
	ysCNVjJg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xT54Y-000000042c2-2GpG;
	Mon, 16 Nov 2026 22:21:10 +0000
Message-ID: <65bab646-fbf6-4da0-b833-2314d568a845@infradead.org>
Date: Mon, 16 Nov 2026 14:21:07 -0800
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
Subject: Re: [PATCH 09/12] docs: ioctl-number: update virtualization entries
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 <eperezma@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, Jan Kara
 <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Theodore Ts'o
 <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Mike Marshall <hubcap@omnibond.com>, devel@lists.orangefs.org,
 Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
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
 <20261114202653.3113381-10-rdunlap@infradead.org>
 <avsSjioXqbCOn834@seanjc-mac.roam.internal>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <avsSjioXqbCOn834@seanjc-mac.roam.internal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/16/26 6:26 AM, Sean Christopherson wrote:
> On Sat, Nov 14, 2026, Randy Dunlap wrote:
>> Update the list of files where virtualization ioctls are defined.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> ---
>> [Since having multiple maintainers trying to merge these would
>> cause some conflicts, it would be more manageable for Jon to
>> take all of these through the docs-next tree.]
>>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Shuah Khan <skhan@linuxfoundation.org>
>> Cc: linux-doc@vger.kernel.org
>> Cc: Juergen Gross <jgross@suse.com>
>> Cc: Stefano Stabellini <sstabellini@kernel.org>
>> Cc: xen-devel@lists.xenproject.org
>> Cc: Hans de Goede <hansg@kernel.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Jason Wang <jasowangio@gmail.com>
>> Cc: Eugenio Pérez <eperezma@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: kvm@vger.kernel.org
>> Cc: virtualization@lists.linux.dev
>>
>>  Documentation/userspace-api/ioctl/ioctl-number.rst |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> --- linux-next-20261113.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
>> +++ linux-next-20261113/Documentation/userspace-api/ioctl/ioctl-number.rst
>> @@ -200,6 +200,7 @@ Code  Seq#    Include File
>>  'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
>>  'M'   00-03  drivers/video/fbdev/mb862xx/mb862xxfb.h
>>  'M'   00-0F  drivers/video/fsl-diu-fb.h                                conflict!
>> +'M'   01-03  xen/interface/xen-mca.h                                   conflict!
>>  'N'   00-1F  drivers/usb/scanner.h
>>  'N'   40-7F  uapi/linux/nvme_ioctl.h
>>  'N'   80-83  uapi/linux/ntsync.h and uapi/linux/nvme_ioctl.h           conflict!
>> @@ -239,6 +240,7 @@ Code  Seq#    Include File
>>  'U'   64     drivers/usb/misc/usbtest.c                                conflict!
>>  'V'   all    linux/vt.h                                                conflict!
>>  'V'   all    linux/videodev2.h                                         conflict!
>> +'V'   00-1F  linux/vboxguest.h                                         conflict!
>>  'V'   C0     linux/ivtvfb.h                                            conflict!
>>  'V'   C0     linux/ivtv.h                                              conflict!
>>  'V'   C0     media/si4713.h                                            conflict!
>> @@ -357,6 +359,7 @@ Code  Seq#    Include File
>>  '|'   80-9F  samples/                                                  Any sample and example drivers
>>  0x80  00-1F  linux/fb.h
>>  0x81  00-1F  linux/vduse.h
>> +             drivers/vdpa/vdpa_user/vduse_dev.c
>>  0x89  00-07  asm-generic/sockios.h
>>  0x89  06-07  linux/sockios.h
>>  0x89  0B-DF  linux/sockios.h
>> @@ -398,8 +401,11 @@ Code  Seq#    Include File
>>                                                                         <mailto:kvm@vger.kernel.org>
>>  0xAE  40-FF  linux/kvm.h                                               Kernel-based Virtual Machine
>>                                                                         <mailto:kvm@vger.kernel.org>
>> +0xAE  C6     arch/x86/kvm/x86.c                                        X86 KVM
> 
> I'd rather omit this entry.  0xAE C6 is covered by the entry above, and the horror
> in arch/x86/kvm/x86.c is purely a 32-bit compatibility alias for an ioctl that is
> defined in kvm.h (the structure payload defines an pointer instead of a __u64).

OK.

> If it's a sticking point, e.g. this will trip automated tooling over and over, then
> I vote to move the relevant definitions to uapi headers, e.g.

I don't know of anything like that.

-- 
~Randy

