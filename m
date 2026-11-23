Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795396454;
	b=zi5CmbsyWWIP6YcQ/4Fam+GvM7peZZwKt/YIGlQtl/6OKgHMFyzsT15Agz7Vx8bqtkbM
	 GAq3PTSrvx6U84peo4eUzpgskES8ERlNgm48wOYmNlP6DdI05KxPqn4HVh3h9BIAjslP5
	 9F/AEk173YcK4hPNj4w7MqeoYvLqQzWfCpMcXtjAvNE8DjnOPnZNjaYteMW7ToVdmwb9K
	 vFNh63HZdgszbwnqP3GQhw5U3SAqBbUUoYcNeYyp/DR+5S8tTg0UKWqahvnpXXtzztHwQ
	 O9ZJGDKJY3J/3f0NdVbUCqonjBwR6P0lwAYDanVSSxl/X3i7SI6Uk7gmnyConHSfTVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795396454;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1nAFz1rE2Zgq0kT2UJ5pKEhQqcU8lxqQXw2MrFx+Nfc=;
	b=pYZrMBTfNg/tmd5x+6LlDdoeixZlNJ55dAWeRxY8ztf03HR0s7/UdHR9gNKc9N/uWePj
	 4CkIGVm9AcUqiXxBqwnrsZb+cPSGX6GMJevdtDz5+Ovu5QxGWCZENhHVJp23xUYqrtls0
	 WiCfI/oIN+MLF2RqmZsp2raJBZnwj1VGeEe8iwJ+o8MrsqTpq+5f3RFNf8mmgpDYOOGnG
	 pmishOdd7aYSQGCApUZyOAiwFORtgvvtqfZafCILuLUB4GraLHtu4L5eaypgZ1P+Rge2X
	 6ZhW1/QNp0FrcTvIJ/w0UhpauL/DmjKewRbsub40ZyTUp5IqRzi42cJpfvrkBkDp5QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5brb9u8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE13606A332;
	Mon, 23 Nov 2026 01:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5brb9u8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C351F000C0;
	Mon, 23 Nov 2026 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396453;
	bh=1nAFz1rE2Zgq0kT2UJ5pKEhQqcU8lxqQXw2MrFx+Nfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m5brb9u8foWKbi7SrlcdW6nE2yWIS8IEGVU5QHSZYMih+9IEkmiqaNM0lLx2EYbPE
	 Ene3Ka2hJ1BAvW2vOWqYEoxo49rMX/8KuHKgTHWJQeFE3NrlIrAf3xeYL6VLmMY+/l
	 ekFXnTI29+zSfV1Cj1JiY8g0iM3LpoM2wMrgHM/4k71UbfvjD94MuJKD4cUZLqKZBp
	 tapIlLzsw5cg25rKFRJ3Wy6OzHRx9WFNJ4Dy/E+S8IHUzJbf1ziPCMSD/LFgujVS+y
	 I6gkNfNt8+7zFmlY0xlcmT0RV+dcWLazJhMGzWNLJfBLUPxJ9MdE0Cw4N9AumibzJ+
	 +Zbi9zcgZuE0w==
Date: Mon, 23 Nov 2026 01:13:59 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org, Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org, Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
Subject: Re: [PATCH v2 11/12] docs: ioctl-number: update platform entries
Message-ID: <awOTV4kbshpi_cxp@google.com>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-12-rdunlap@infradead.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119053514.255348-12-rdunlap@infradead.org>

On Wed, Nov 18, 2026 at 09:35:12PM -0800, Randy Dunlap wrote:
> Update the list of platform/ files where ioctls are defined and update
> the ranges of function numbers that are used.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: no change
> 
> [Since having multiple maintainers trying to merge these would
> cause some conflicts, it would be more manageable for Jon to
> take all of these through the docs-next tree.]

Acked-by: Tzung-Bi Shih <tzungbi@kernel.org> # cros_ec
