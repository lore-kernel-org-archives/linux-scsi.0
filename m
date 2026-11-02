Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633075;
	b=FpwbNdP1ImMEOh+HzzY0Ovd1kYgi+uq4GkdkbHpC/G/MPQlqXK0ocrAwTjEeb0Oe9McF
	 mt+vuJ6IhhDjulL775I3lYqUJyI5xyZEpG/CqhGkz95lDNaoH9IoCNMjqlhHxAePpIkry
	 ltyHZVlZ/22Kw2J7H3mE8l/KYmQrOVpMT99kDIvQbaJHdvewr0YtST7y+EaJJTLaU66j4
	 oh3DihoIMuMK1tBh/BSSeCqb+0dIpejpSZhzcewAhEyilbdvxBEAy47F3bJNXhZ34UsJy
	 hEtfLgRDCi12wXGvSqAI0BEAHogOT2N1bGNRLhBTGN+LCRxBTyGU5mrfRsX8XefgO5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633075;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=hWdxbpN4QmmVdM7UmPZX8KG1qjYZ0FQqqjiDA/VJnOE=;
	b=ySNKECQ0ZTTYlP23zwXuTlzelPqqZ5dWWYxyvyAQywRHziknSwqhCxK1ameMdPTJBOjM
	 cuWK8xuI1gh29TUVfJgAzGPZR/Rvdkrdjmwp5ydrf8bRsqSqIKOReqY6javc5FImUmIyE
	 9l4qdK60tBKSfE2OMieoNFO8Fx5p+vtWy9bTZ92UVedEUUAkFuJK66UrXhS0Xa+pskTY1
	 KK32/ca+sUAwPFgOHBypoMXOtigw9+Gbs+g1cCLshbpG4sclaE88Avjs9/XHOSNEQFoy1
	 t44w7DHOqyKPZFXXpo4X0wx0mCnqZjCnVDOaYEL7WWC92/YOpfwwyjjArwxlOo9s9Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2tiXcRL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF4360C95A6;
	Mon,  2 Nov 2026 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2tiXcRL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843EE1F00A1B;
	Mon,  2 Nov 2026 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633074;
	bh=hWdxbpN4QmmVdM7UmPZX8KG1qjYZ0FQqqjiDA/VJnOE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Q2tiXcRLjLxp0Sfv6TzxDOmLL749D8GFuBHdfpwBAeD34WSvlzVQOB66VPbtBDtEP
	 tLUMLSHppp9BGtNkx+iY6knlxASDjOHhObUbD20+r4M0FYR3O/t15nxWT7pSikrSQm
	 l80se6jfpCXXfVSnxGTpz5QshYCbpTErxlP3n0HKQQkJOPoxQWfQETJzTk1O0FgEqa
	 NmFdXlbeNn2BqDteoBNofMcN77X42d6NxWhrIvHLottL9yHP484r9SqFFyzAriZyEL
	 lYmT6OSXrQToiPByeQlZYEnbo1BZqOcbgqlCBnqZcBLQRcB8vex3ik09oALFFv4tw/
	 P9LF12YhVou9A==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id DF743F4006D;
	Mon,  2 Nov 2026 10:24:32 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 10:24:32 -0500
X-ME-Sender: <xms:MKvoamktWPzVHfGfqMnfBUnX12mAfqCNpYg1mnZpsjjQlytnP_GDFQ>
    <xme:MKvoaop_snACaCPsp8UbIkrX0VuTUqCS69NZfmyEg5VuQEMOwP74tDssm1mbMC7Na
    L4psiUcO7zb92ZqJJXrSnVU02K155UK_Jvir1-pnBpDMj8LrjlTIfw>
X-ME-Proxy-Cause: dmFkZTF7ntWmEwgGBlbXwlipOb1DEBDQAhhX0OL7W3ESE1c4Y58F5UnDJyEt8dnhIEkW49
    bSUNjezLoMpeptFAstes/dup+GOJHwOWVb/CWlJyXGn193f8h3l5hsZNShVjOQjsTRohCX
    A7NtHx/zL2ejOFY7nM9kfOFgoikYlrAckYOu8f7hASCDsja6Hrk1rI2T70O3iMDfg2SxYY
    Zur9L5i46jczvGC4EKxzEWA1pfFm+yB6AEfDhOzVlEFraYBZk0g/TI7U6Rq0NVJniUPAx0
    Ms7uiqAKvKWNclTSyqDyA2iZMVN/pSNwwcfh4DKH9umqsend9fzIPoI/wbZ2BY53mtMFZy
    zDHyo9usdkoEZaEpmTNoGa94y6UWs06X2+Vvayf+hT5Q00wB62DyIvXiaKtIAqQyvgezJX
    gMQyOIOZt2s0Ka06QtKc3yinHtSyP17AYeV498V+x9QPrcYPy/IjcANtd5PFTt0p4ZP/mb
    BYBzvQSBaIjqqrl6pc9hfHnF5W5BzvpNOjFH5WhHliptZEM76ApxkAEWqTQikHqy9MLimT
    SOmvYcd4EnPUd4aMEDJn0RYBZW3qZ11uB8PJIkz4XPQ45DzjQhNh88B7wEg8tgVl/zJsOZ
    8EVVdmAwwXqghCDy2L29cKu7oFIfpgdJuXdxVYsukJyDY7oGAc97hUYTlUrg
X-ME-Proxy: <xmx:MKvoahKh4Qxz2XET1vMc0TgeYLzxxsBqS_5-gXCDYyuzFKNMCpL9Gg>
    <xmx:MKvoajCApUsLjsSQE9T0YLW3NG1H8MteSFyAcNeQhGG7lN4po_K-oQ>
    <xmx:MKvoasLUqk4CAxihafDuvBm16uXYM-rD8PxB1Cn0GLv2DlrRcrPt0A>
    <xmx:MKvoajioD5IUkBoHBGTIovYDFn5dB2KnImSD1Ef9OftQO8lfEDDkGg>
    <xmx:MKvoaos93Fcbt_R095IT3GL8KWMxtU_fU-6c7khNrkI4NMTo4hEWeMfk>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AE2CD782738; Mon,  2 Nov 2026 10:24:32 -0500 (EST)
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
X-ThreadId: AG7Lg66T4xgg
Date: Mon, 02 Nov 2026 10:24:12 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Jann Horn" <jannh@google.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Chris Mason" <mason@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jonathan Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>,
 "Greg Kroah-Hartman" <gregkh@suse.de>,
 "Joel Granados" <joel.granados@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 "Takashi Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org
Message-Id: <097f592a-d943-4740-b99b-8983527095eb@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-4-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-4-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 04/27] lockd: let procfs copy out reads of nlm_end_grace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
