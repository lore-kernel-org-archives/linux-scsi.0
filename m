Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322549;
	b=vajVZcM86HOVBBRijJ3BKgoYXTtQpG8JOv3V1Gj65iKioQ61AFYDEwP6Npd3oM2MUdg4
	 Z1yi3rInOHRpa09uu7moI+/KbpcUr4NZRygARTlXft/ojPm5cVAZk6QBFPfVbXC7G09CO
	 fqALJ+6RbBGkL0r15FSjJD2vLPrF13JUeIxEQDVv+P0kJG8v2JEoR26ze/3dwi2DZqs+C
	 r5moNmRzyXuW7BwFpn1uSjUvDRG/p17WYNTyk/twSeDdZs2PDYyZpKc7i7qS0WcbcVNbh
	 BaVI3/hIBVM9CoaVkjenr1p+K9dow9UONLJKz9tPQ6KhTcU9+kT9sVBBDRxqfaE4qkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322549;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=zSjXnOetE5oKa5v8S9LBrUhcmgizc8ch93AeD/W6gEI=;
	b=lxNKUqHUlAo1hRb6idS/ytGxwUOOVNVneiL7kv2xyKspBuHuNn1Z66CeL2NLo8mYSZUd
	 XsdvjlOYgmnisKfWYP4KBLkwWrqiXNx9tMuNoeqtP2k65z9aEYr7vOn3hXahJTlctAZ3V
	 Fnm5xKVqtTPmmhJlsl4WxqLS7H52DTnTE4Drk16O/gy0x3znV4Q2xtdcFx93DZzMPuFzv
	 eKIjrHoYh+G45Me8srl7k3f4HuywDOq/HcyKbG7SyKQI9Str/gvTnU+9/Njp/MCc7iDR6
	 BciyGLX+JoTkjDhjUQG8OY9Z/Spfor0wlB4xVqFG63GA3WXKVxc5N+Qosk6vxicaHIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Tcwd7Q8/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75008606A321;
	Tue, 10 Nov 2026 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tcwd7Q8/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3591F0089F;
	Tue, 10 Nov 2026 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322549;
	bh=zSjXnOetE5oKa5v8S9LBrUhcmgizc8ch93AeD/W6gEI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Tcwd7Q8/BgCZr0AJA+q53XtkaEXHNBQAptcCIoE3INOkDT8T++JPLwFgnijhu6LIp
	 QoJCfJqeBNhK26M7LL9xd4MzXxKVISVDOEW1cYrYEyBiFKRmR2hdLsioEex6m+2Rc5
	 2AgfVzjCsuMDtAVvAKOrFX1qXAfAYeUYjVl2rownrESZ29DXkmWTHYRM7alPMZLQ6M
	 DZH727vPlYTYzZb+oco6o/Bkhlk4m5LBSezhlvCb0bhHHiXIMbUlIMDObU3PIfYN46
	 k7napT6YlagBuXnh78UDBF3WtFBwiJfcd2zG9H8WTZ7Zkc62YNaLopDBhwYuzfc472
	 iPuH2WgxnRVeQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id B2761F40069;
	Tue, 10 Nov 2026 09:55:47 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Tue, 10 Nov 2026 09:55:47 -0500
X-ME-Sender: <xms:czDzahOxHA_IGoa_FJdwV0BFPQw-nSdKO6kKGUN5puCfrxj2G2sK_w>
    <xme:czDzauxKYck9zKSqhpZaTHxPL9lIOi42MPCnrNTR7eaQqnpkmbe8dEx0PuhUogQkg
    tb2W38kOzksOJlDJ4uTGR7-rkbiwtctKuF5oVtOm556TqS1yjjUw9U>
X-ME-Proxy-Cause: dmFkZTE8jIcOTzT9axQiHwEjJScKTRkNH3ZVhgYbwXrBMnGwr/PZk5kUfGxy+RC0ezRM03
    2Axgl1A3kstcvJQqQJ+tEirxS634eXBQm2b+wwk+7byJnMoEdYYw7Lfb7185Bnwoliq1Mt
    XZ8lliUhOZ8AACZwbl4T2Tc7NYRy4GvnOujvSweRGBGAD4OQXGjTipshhA5n2cB6RQlk4p
    zmTRFZMOMjoY8cueG7e24ndoN2R/gq/lSNUbCVZu/PUOrAg9f6aovYYa9SSKBBYGtgXYMN
    0qbpFOi4S4kwXDcxuFcZlmK43Jt2p3+0W9uSzX8U3QJynW/odwma6a1hhpAbc8zEaSnbtk
    CFI/IAk8YwHJ0hyg7qaH8oiiVC3V/1ZiobIhoPO231VrqQk5oaP4jl+jS7yMnBbNxynDhF
    /tTsfxMaF/A9xwJBu4sKm+3lzwzMEEbqt79mE4Lq/VAgowI2/Z3gVdFMTE48DIB1KcUvAe
    gGFx1Bx/tQmWXfeE09uUSkiQ2KYN+OrlgTMnrepjVRxO73rY2t7sodPh2AhJIAG1ZYT5ga
    3nwb3G0mQrnmFOm4Qa4C2JwbajMdJBWMeam4uZKQraajbqcBHzCXvMtQm1fQbm3S2rexTo
    KA6wW/vDabSoXlut9Nm5uKTSjp20eGQ9lpLOxOz31c8eLm8Mlp10sjOYDNZA
X-ME-Proxy: <xmx:czDzaoanLMdLTFqhzMhrxv5H09chgFe3GMMhc1XBCkfiMJQ_ckta8Q>
    <xmx:czDzauzWTK7EYc76X_4JSXvP7e9Yqejr2yggz6O-tuvCpsEWBQGUaQ>
    <xmx:czDzasWQEDY8T3p3eaJhPzKDKFxYGPCQnFb1-n-prg7tBs3f0gJpWA>
    <xmx:czDzaqbpJaYjvNkk5zy3xoww5EsXMA5_awnvU25FYCgSdhgQQ41Hfg>
    <xmx:czDzavOKwCwywHfR1JNgdmNe33GAeUXrw31wmu_3YBRbMsucyl2ChD_t>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7D2B9780070; Tue, 10 Nov 2026 09:55:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AKCAcWHxcB8B
Date: Tue, 10 Nov 2026 09:55:27 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>,
 "Josef Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
 xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
 linux-s390@vger.kernel.org, "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>,
 linux-usb@vger.kernel.org, "Amir Goldstein" <amir73il@gmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Message-Id: <47b8b8cb-aadb-4f84-aa5c-c5a74d73fac1@app.fastmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
Subject: Re: [PATCH RFC 21/41] nfsd: use fc_init_pseudo()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, Nov 10, 2026, at 4:14 AM, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/nfsd/nfsctl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf..ce2666deddbd 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
>  #include <linux/namei.h>
>  #include <linux/ctype.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> 
>  #include <linux/sunrpc/cache.h>
>  #include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct fs_context *fc)
>  {
>  	put_user_ns(fc->user_ns);
>  	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
>  	fc->ops = &nfsd_fs_context_ops;
>  	return 0;
>  }
>
> -- 
> 2.53.0

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
