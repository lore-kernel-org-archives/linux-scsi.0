Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872960;
	b=3AYzuADItDvFo5rbnoLdNNDr+GXT252rMi5lqOAohw9obVak4YQA0v7qE0dwEuqMoQYS
	 PCPhOj3whxZB8E6j0nKPiWZCucFr9gFQGrkzqbAaxCzKDVqBS82uGrGQZVgunNAkRclns
	 GoWZ9jJlv9CGq7lfdv/rxFYboMbwz+8nIsemJlmgBXyyQf2ixkYpF52I2e5CpdeCY5YeQ
	 kOgbRX4aKtozg2cJzjWfi5j2BAqnM10SZowrkppYWj9qh9TvNx77dDBzsA6p0wujfUwBu
	 /75g/g3Z/j+DQALzcB0Xj07reGnJ9l4goRUusIjp7fMoHGwoS8HywwrfEzlzlonEnXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872960;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
	b=w0zcPvR8lSTTfryDvoqQh70gNtWuOJIL4JX+9HJ//YfCpmMK1+VUIUPw1nqaF0/hQkY8
	 UnEURYPYO+PytoIvDL368lYIopkhEIzmAww/9nU6vLFNiAK3j2cLEi9d/9jG5I+KWVg8n
	 HWFUG+YBATFYa4V9AcJLMibZZtrtJaEJO6kyDmbSflBkb2m+HHVuqGEVhK1/0/gpcNq0X
	 T1K8l5Ec3/fCIdLsuQ4sO6gRtpRZ7gQRTbobr25BUqiJW1y4XpIwa3s5zQ3OtBIJmb4qU
	 K+r75Ey/o7fFx6mnrH4qIP7rUmy3megxTnQbWfZq6y9/xTUCeNgd/vJ2Yz/tJOUI3vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13796606A329
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 10:02:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13796606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91b8306b9f8so25770496d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 02:02:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872959; x=1794477759;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
        b=oVktg3OZQCl1tsyFuhdkAvCTgDzY4jIDQGPoBM4dTJaCt8yxQWZ2AKfX5oU9Lvt38i
         xjRQhh6uJkLnpwIgYIdAaKh6y0WpmepGTinXvdB6qMRplZt0yPG/dyh8Y9ETlOStJVtG
         Q8hUWIaGDZB3pMEom9D1TVM5PPBoTyiLaPEQSIcZxYEDqHURXFj/OdxhPSikQIvroiUa
         ecThL9/hwpV45YRU3LI+5F7iME/Xr68yxnxrJlDuHgnl0JiN65tALs9ABiXlwvWgxX42
         jsg2SEg+yeIs884MCUA6TCERJ97oRnu6i7lN9dES/sG61cOtqdw6h2bpEqFkHzwzheN/
         pnPg==
X-Forwarded-Encrypted: i=1; AKwUvBz0oEEx4wsI2FbSGKSKLDtOdd3C7wRrok6AP1A91GZ3/y1JqNncDP/eJfk9E6hbZ+mrvfpQhXMzZqfb@vger.kernel.org
X-Gm-Message-State: APuU4Z++kgHtI/NheyHIBLRW1dACm9rYJSFJjeSTEd8Nnm7e2aED/N79
	qOF+hfTrMRrjQPwllDSbPmRQA4b2DvAll0ZWgmMJtCvXK6ovGO06QSOi4oAG8S4ayN4=
X-Gm-Gg: AYBFou0xyfCWHg1z2cklYk9srYvQjesYzJFLpG/y/cdEoKalOXFCmLFAm6qCjTMIOlA
	7CP/rFnfTBwcWFTcOkLs88oF5i5X8A2ivJc+aNxtkvi58pcR0OP+0uCmV/0fJV9fXVRnago0VV9
	EKrL0yfOtdagQkVY1Kv6jntu7x2yR2taXxxI6FdJ+viJPPHD5UbKJPCn+6TOMcMs4Sz36X6TuoY
	Z1zaY91NjigJHXtl3TNyvbXXIj3ScGcxZYr/6VOwVYoSEwukXy2UqVM+LA+CG3hQczyeqecyXZz
	pkc9QWaJP8I6hPQcP/eWqL51HI6FUgon1qpFZtDBfdF9UrOuQKjR2yAAuAbyw+m5VLknaAn5xNC
	4MolhMWcTt/W1LlAu+06uyXeUVWVsQ1rnAv57fiuM7uhEH0LXFPqesgZuh68UJHEFfA3i7YjN1t
	mzUYfLO6huiAMtD8S0ptmE6VgOmUZ2lTi1tfaHaymD6VM/Tm8OMY+S59ba/EW45r4SRJmNRFl78
	vtTsGDU85X2++NMa8H/k2opscWkZktvjsy9tr9ISvu1nC6reTiDnnSdxUV6asbmoniZY12ZhmIM
	NMYqOmt3K7Wq2WDbnZUYiSIMKoCK+IYN9uf5AnP6KvIutFDfRAWsPPMlpnA6SasFHny2O2LB0xA
	/aGp/4QwrSTCUBsM=
X-Received: by 2002:ad4:5d41:0:b0:91e:91d3:82f3 with SMTP id 6a1803df08f44-91e91d3888bmr46387986d6.19.1793872959104;
        Thu, 05 Nov 2026 02:02:39 -0800 (PST)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com. [209.85.160.169])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7dacef6csm43357286d6.5.2026.11.05.02.02.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:02:38 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5364042eecfso22737711cf.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 02:02:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx9EzA6E+C6/0Q/d7JNgCNaIft5jU+WY7XiUXoLIrOML3lkL5TqI7neayzAMQ56J20Jby072YgV0K+Y@vger.kernel.org
X-Received: by 2002:a05:6102:5108:b0:7cc:56a:58e5 with SMTP id
 ada2fe7eead31-7d072d84a58mr8269567137.37.1793872526219; Thu, 05 Nov 2026
 01:55:26 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org> <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:55:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
X-Gm-Features: AclHuK_UsJ1nGicdWEWcMLQAICTi1A7pGF3yhNkxXkXRPqohle17eXAHHNBsR6k
Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 02/26] zorro: let procfs copy out reads
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 20:43, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read from
> /proc/bus/zorro/<slot> to userspace after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
