Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686757;
	b=JzwBUEWmoMFyuJI/GGny5J/Xxy4d4AFBlam1cTmuNAYNq3Ywv3dMZzQQjnX+AmBXWHBB
	 n0Wv3XudrGy66AreBhQEzlVfIw2jBZIrwSgYa4CAsZMFSyAKdVN4H8QK3eq+thedOIeUt
	 72GhBkOFTU8m9cE82GNQMMpOAg0wR2G25MJwxBqB4TLCdib7OYkQ8b1FevJFWHFbE2RzY
	 3TkfDnFi7px37CJyGG7jG4a9MuIvbPWGgvnqcjXQZ5fb3SyDCP9P87AJ/1Wme8Rl4o5+3
	 mWpNV0sZANzmrRgNBW1YurdCQDPGNTzxgX3uYkXBK0hqjqXKZ0VXW9Un9XDcyhUhJ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686757;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
	b=KbUFPqWvSQy1TmvlcvgX2Hd2r+B3IJp1ST7WyWZTUfoi2SMoHa29r4sWSt3F8Suqx04a
	 PSfi/grn4PLLA29vqNhmSaHd0vE1fIXHNfEY1FRavzxZViKsy499DKmonMNr0AXRlL3+t
	 zT3yxISPqFOCqnG7tpJ6n9996xO8KXS9EinyNsS4BbHM/06vWaxcMgWkCI1eXogfiiKFB
	 uu5aZx3lhV/9wRGNLvOJ6GV4mmlYcUZCRbRDqekKlLu0YPDX5Bmj67KQKc/xt3MyLKGn8
	 V8EehlN16LuLAIgoNoWr+LGKowbLFsUo+PZUJsHtGpG7xY5udZj/oSV7bkL51Dvpjkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZNpsvJMi;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4A3606A32E
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 20:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D4A3606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZNpsvJMi
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b2382bf051so1354516b3a.3
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 12:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686756; x=1795291556; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=ZNpsvJMizOoFFuviUq3R3I7xBszXKHR6f+dU2Lhp8+AdJOsuucW/Jpjz4DKxOc01P8
         7Bf2gXYBYorSyL2ypHSps7l13uEx7uOW/BQ3oCjgyM7fn4nszFId/ZhifmOhhkUhMak/
         Krv6vg2ZKrT882kZ97nfZeCj+rR5WiJ1p/wW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686756; x=1795291556;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=rVyi+wifFEq6Hv2sfCz9LkAMPZtUogS5lc+Xo+eh2PRtkOpmxhGNQMcq31nCGWlEl2
         SWUtm6pZJOA6jGMpmEK0cibYizpmFK/2G7pIhPIeubJXswoQG4Pt0i5jLZYfcfo58cqN
         thvAqJ1oW3HXp3Gd951wKD54t2OT8ET3KuTbuDdd/q2ySoKPmwhRI2Me5bKO4rPbnMhn
         HvJy8c5px0j6Fd8jVHLbnu+xN+mmsjDgzfcgsRmynXiUSmyBHbx0X5rXtg8eYIvUkroI
         QohqQGSMS/9CkbkUSBLV7/gcjeJeGUUCMD910y05P/cQMMt8Na7J6CBWd+S1ZZThRqwn
         ncIw==
X-Forwarded-Encrypted: i=1; AL+hErH8U8E8T61MLgV7TOO1Op5SysqHKF7TF5ivcvOrluKBUvM1td3cIe/pHw6jTY+kNJDdVMnLqdQuwapd@vger.kernel.org
X-Gm-Message-State: APuU4Z/2kVbZ+kXbgYkAdmOMsvG/h7Lx/cvQl0wphZbMPui5CupsPhwR
	LgdkBz/sB8VBmvCyhZwVwHoonDZnTQMGQhBE40KxNsElzHs8MLIPAU/XbZKO5HIUnY8=
X-Gm-Gg: AYBFou3CLzLk0wzc2FPpk1lpn+3XslrSA7tQOKsvbQRcRDvMGwqMD+m+nwTEwX/PAm8
	NUMumHHgsS5kRj5e7xFEvSo3ucSDx6uKP5GmrlZeLmGVeAUY/ItihDT1EwHAGDG89vfJR3DOpJl
	4eOHDvEzxrv4pz9bDfE4MMwPduH46jPQhWBwob4hes+3yjRvSxKPNBJBB8WJt9rfMhdtAB6B0bg
	3O4Fkl/TKNa+pz4ruGcMahHrSXEJjjd7WqF8TkY9REcbr5Jg/34Ase7lkZLULFe0Gz76RcqqHbp
	m1WGxs3qX15k/55enUH8QzDjMpMAQYm5MXVq5itmD62nb/DRAusi79ileFksVfOxUBdtFX2gsT4
	AkFrgOKtlHhbB1/dSuWYujEzJmC4uK67MUTQ+usNV/4YJumMmcv7ibZlYKApCl6cDVeCBGJ15Cz
	A0efl6aLM2Vgc2DaQYr8Wpi1HhfR0zOLSC+Muqj5d+TmXx8VrWDrc0Cdr9XicnRLGRGIHYdDiCU
	HNhHJ8qPF9XmlU9oANOKqhDd69r/vnX7HAPvXpjIk1/0xq/klneVKVgtqzcmxXQoeOw7twRtZUd
	NpV3vaKphOIQtAW4zAvIrrhsM1yosNwumsc5+/MQK/671x/goXEaGl0oSCRaXwlHgNpE+RphptH
	2Yp2SeFIs3LU+7uqiw4clrXpPwmoFaC2xaa+WaTxFa8oJfCrhY2HtPq5koVQ1rJKaUkBfPqrbSl
	EKomVxZLe0EX5x8z5DQ7A0sMtWuWs34ZRxxgam6tP9P94js5koGFd+VHik
X-Received: by 2002:a05:6a21:748b:b0:3e3:37ff:3795 with SMTP id adf61e73a8af0-3f7a4dbfbbfmr5517650637.7.1794686756009;
        Sat, 14 Nov 2026 12:05:56 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8172sm2271197b3a.13.2026.11.14.12.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:54 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:50 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org, Alexander Mikhalitsyn <alex@amutable.com>,
	Breno Leitao <leitao@debian.org>, Casey Schaufler <casey@schaufler-ca.com>,
	Chuck Lever <cel@kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH RFC v2 00/42] fs: don't use pseudo filesystem files as
	storage
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120550.0c9e73aa12a3072c@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Patches 1-11, 13-16, 18-26, 28, 31, 32, 34-37 and 39-42 look good to me,
so for those please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

I've also tested 5, 6, 34-37, 41 and 42. The selftests all pass with the
series applied, and a uid 0 without capabilities can no longer change
/sys/kernel/reboot/mode through a loop device. So for those, please also
feel free to add:

Tested-by: Chris Down <chris@chrisdown.name>

I've replied separately to 17 and 33.

Thanks!

Chris
