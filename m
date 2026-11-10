Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794305680;
	b=QBNQhYY6+GbLYZ0Cw1foQXoYMybEA3ZQf5hOeeOXV6FRTiwIwIFM060i3gHsSel9bMEY
	 O4Q4yU6RQ1bPvmzNQ02CaQ2vrCh64XImxh2Mwvs7RGL2tUOO1UCH/ZKnnwwOdiBZL7gmg
	 nLknqndP45PLzMH+swyxSzJt7Dz+oDw0FYG70gtZC553m0lhUfN3dv6oHrxbbwUXYI30S
	 r9NxA0J2qZ7HCcdksVw7a1aR0b3Z0rIRT0W8TuUfpYQ60f3fshRMTr5hzJttr8pmIcfbu
	 UzBtWi8i8ieYgpQU7UQVTV6UXDUzBCIStwCdt6AJhyq9nx7nUQMvNmLCcGdTlNaKmog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794305680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
	b=ajOTVZf4YEIGiK/CRJabg5Yplu9aZ6YRV3VmSrSFkmDPsCFy3QgoqhB9isZJ0sBL33dM
	 xCQANiq3jK2jzcel5v4vO0iHnNlZfjfn6fL79CQlBXH9wmkHTt2jcfZ/B1MK3X9VebhcS
	 Q54rWKy/92mPqp2VdfNDgfv011LDMep4whDupF8GoDr38nNqEoaH1rzJbWMKi1rBj9do1
	 upf+k8X+1PjYHQVUHMr8lGEO8kJQbnWtgnublwAGU//JgF/5KiEoAVV2TIpjc35maPrsG
	 e52hXbJGA7ZE8oUgvp0rSJRFVwuxlQLzIgoGvmy4OWjFmeiTZOWkkGxh4TJL0ixLqmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DrlQYRb4;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800CF606A331
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 10:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 800CF606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DrlQYRb4
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so271061866b.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794305678; x=1794910478; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=DrlQYRb4d+FJBQLFk4gip1vdMb9pZcbFm0QRoW/O9nsnnIGk5B/dcI7komCKzkv/uM
         Uz0TTkL3EB0XOLA2v0TTxwYvqDOvah1wiwbB4uUsiRRXfj1OcdvtnHWnMQS6yfKTNN5Y
         2S+sbZpFj/oUd6OIfB1K+t4luOgmpm8MRta8dNUBz+XdEb16ui6jztHrAySR2QYDDBtW
         UcH7ksMk3kyTCuhLg24n4RSbgP43bR1MD63YWBBHbNHKba+s6Adtgd3r0iiTavTYgvkx
         vCBmyxhjfzRfUpjuhY0K7x1CK/3uUIf/0FzbTbFW5bHu/k5G1xko0Cr6O3LrrObY61iA
         y+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794305678; x=1794910478;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=C/qM93d1d71EBnxhB1+9fyqWEJRlEXl19V+XnJnUWENpcuePIBo6HF4lvVAQQzlHSa
         a+Tb6uyej5cgv8+3fN8kbNtjegMqy4Ncy4YC2ZlrPy1mn5GabiyqsvscSVpmXC8wu30N
         qxOq2VV5GxQCMNizFI1CDfR/AKf7FL6acKK6zF9MsDRyYnKgiYRIpOPH6OS74v/F/AqV
         vXVsw8tUu+jT7pZ6LyexsGa/Cc6sXB/ISE2J7v+Ia2pKro84YThZqp/anelXMLkGIq1g
         gzIJJ2djKLlwrjONDRbHtt/3I757Z49vkh5jmt4KO677GMg3jSGj/hBHgfT6iGoGnlIY
         1VXw==
X-Forwarded-Encrypted: i=1; AL+hErEtJqG5kXGW+xhCj39ilzW02Y4HXIPHAF042mqayTI5iqjv7Kxsmjfvw4CfJSRBeQnDdi1ggL80zyCG@vger.kernel.org
X-Gm-Message-State: APuU4Z/E0VVe7Wn4Pe4iRQuJedD291/ssJoMx6ZMkepPJnpfWWIl2awn
	7qhSVT8o224Iam9+gFB/YQwZwX0ujNMgrYsdD63TMhv5XhPER7Lj1K/P
X-Gm-Gg: AYBFou2d9zlpipwY2fA7nWaK0u13B4q0N+nxJJPp7glJyHBObMzYzIpFSNlzvLFC8gL
	UhTY4t4dmvCbELOx64b1QbJbtOpTIcwVtGz6GF9KzxVl70EYG10z1PDGoJIXHJL6oLZbb4nMvUg
	wSIJINamHd1/3O/d4lPbcklhZMoQjpuXrYhqT2tSKwJ6PQIG52KvbYJImyLg+q1ky4KoWJNPLlH
	KjktHIw88njM5smaegil1wFzGrcXF/7A/xFNlwwDfLk/S5IO9MZPRMvWdvi3jqvXCt0nOAyzJMS
	tlCXsByPnofXNFIm2TBji18zcdMY4FjYuskSqDFOvuuUhOj8sSOP4QqY2ugzcerka8fHruguArc
	32S/xWvcOKq8TnonLafpu27Xlxu0QmCJC0sERfXPvhX5hUEc11wDGG5rlcX3/GusnqnSNJ4DPOZ
	l4lUrXElSpH3hPvoIqaIbst8WWVJxLjIvUZj1O+TuEI6IobAoVOmy1YJeTGOZTal4JCdNo0rnw1
	KGo4q8R1HavedCfMD2fN8KxPAZJqNTQvVAV4oi7FhEVx7AotBY5+G2ZAY5yh9EJhs+O416WmD3S
	kqyD/4mOFWnSBaH99gfpKpJsGuHCJIcGKLqlUrJJYst90mp0MDwvWncJXT/S4M/R+8bBg2FzHoT
	OKd6ONyA2N41D
X-Received: by 2002:a17:907:944d:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c504963ce05mr189793966b.44.1794305677695;
        Tue, 10 Nov 2026 02:14:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a593eacsm90433466b.36.2026.11.10.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 02:14:36 -0800 (PST)
Date: Tue, 10 Nov 2026 11:14:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avLui6Mpf8GbKbtc@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
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
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>

On Tue, Nov 10, 2026 at 10:14:54AM +0100, Christian Brauner wrote:
> The fuse server can register any regular file as a backing file. procfs
> and binfmt_misc files are already refused by the stacking depth check as
> both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
> other pseudo filesystems aren't. Reads and writes of the fuse file would
> then be done on the pseudo file with the fuse server's credentials.
> Refuse files on pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/fuse/backing.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb..4e4fb810ddaa 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,9 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
>  			return -ELOOP;
>  
> +		if (file_is_pseudo(file))
> +			return -EINVAL;
> +
>  		fb->type = FUSE_BACKING_PATH;
>  		fb->path = file->f_path;
>  		path_get(&fb->path);
> 
> -- 
> 2.53.0
> 

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

