Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793263605;
	b=K1SiJ3kL1JRf8a2H31TZ0kWNm+/v1rr5K2HUI4RWoiM/x74yJDbsFJnYus0fb7sn4+Qd
	 vRca/6iBOHkfpcrZ4AlbDUpidOoK0sMzjGLAz+GFpf88Us4CasiK5DNuXtNQ4YbMFT9uJ
	 u9/qbzHjhVnwYslShAQT006zVL4PH4j+wEKvs/ImShfjlnxGD3d/U1kr54TF0V2a1fBlr
	 0RFkhoZ0npCpUDImUY6J/xhmzCUnw/d31sr/yIiLh+tZ7PiC36n4Ns+s4yZqm/aeCGP+y
	 PTIbEmLD3+ZuYBspKB7+HOqDWZSSHKFUkKMcWFrMWYR3JFobgreE/q+6ulR9tYiJjHg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793263605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=a1WpD8CKMCmTwyPtEaw5nz6q3LRedCj+B/ByJhgWHZ8=;
	b=UL7RovRa1JMDFMigJ6/wkgNwXX+Act9W116DmNDuFte9f3kSYiyc0YnEI3EMdc+bCxkt
	 6hX0BFOroEV0Z7MKU7pYixTwvc0MMYf3USdn5+c1FOAJFcKAOJAdWYH3poVlI2W1r1dS6
	 jedpo8YlhRqU2Fj5q04jwYxKAk2Ez1kWyp+nbL3dl4Pywl5T61kfxMsvFvJyxUNZLKzS+
	 T7DKM0kW7mLLTQbY3PE49l4no0pU+BlM1lzxjCwM2/OuXbsI5eFp/z+HnBzfZ8ADJ7eMU
	 gRJ8JM2bfHfOzrwEuJWu1CdZ/j0ddySvTbm+c2usgcKopx2OTUsv8Z+URLuvr4SnXWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=u6k66prz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364F4606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 08:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 364F4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=u6k66prz
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c46bd7a7345so88403266b.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 01:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793263602; cv=none;
        d=google.com; s=arc-20260327;
        b=GDpmee8gJLeIdoCNB9DpeRl3FZDyqJicJ3Azs7ALeNuzkLwqNg7QEzsuIVgcX+xIgj
         psIxz6DIMhXlBJwtBWm0AhQIqx1vegfLyYAR3FaW6vfdgy7lODmvlBilRFySx7ZYXMmP
         mFFcQW0C1gT6KAa4uE4l9/NxhnCtSNUFy5einPSaQbUd/NRTttRvXf2GisC0h4YNrJu7
         oUQk9LGCsMnklRvmi9e1v/YDs4HquR8SfqaB3HfN7fqLMK0Mdlksqt6rj7gE1ZyROJci
         z7nikLjZFrSVUpVdspVeAUBaldOMRzFEC4F+ieTV6C8mZlPd3rP4OHM37nSxgzcWSv3Y
         Vr6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a1WpD8CKMCmTwyPtEaw5nz6q3LRedCj+B/ByJhgWHZ8=;
        fh=n/q0ZYwJvZDh/nQg3qiY6W+Yt2XFcgO2a/ZRHJuhGug=;
        b=Jp9b1vYNeY4f43AaIMjGjSEHjoqfiH+amSZyX0oqUx+Ua0G8J230j4c48Dyzfo7l3U
         MhBweBMnkjMwoTnaWzRnhM37pCFtrGfK8SFRnFiQuBLxw/0MjMco+4t4P7Y96244Gycs
         GqvfC+QrPyBnzSAPZj+FqCqDXXZjmY9o823RqPtbZ/iFe7Rlpd58+RIZq4ghWNG3OELE
         C/CJ/k9VZ1Rkua/5jvu9Hk4H77ZUt0mK5rJV4Xfm1sifcgekwc9yPdjQdX1F8dPiz1bI
         smaeCEX0osyHzYVzFKqJF7ExV7C9GKsHRlnMEZuyV7f3waSohHEfRwfBgLrmcJqHthdF
         soag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793263602; x=1793868402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a1WpD8CKMCmTwyPtEaw5nz6q3LRedCj+B/ByJhgWHZ8=;
        b=u6k66przy6QnhjhFElLmFV6aue9wU04pzaX3L52X1Sd1j3GO7gb5wzU/TeKvDmxgCo
         8n+k+Ker1fU9c/mQy7VK1m28/g1b5BsPn9LJOloUgLTkLQaQeTUcYJ0WGSUwYLt8Hjjq
         uWCwnnz7bsL0yuwjTSlZh1NwTWfiDa6D4yZbI+LHHHhS83WqHopmn7iWz304/cBxNBI6
         N7vzzZnUeAjP5/hg95H7ZIApN89/jwKAj8tEutfGNcHkCotzj4rbQfWMIkxyyCReV1wC
         xaIrcsXwwFpLRUcOdOlyYYKTMZdmgdBnu7jQSNlDsTZNgHnsURYEH/o4vkoRN27pjL6e
         pssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793263602; x=1793868402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a1WpD8CKMCmTwyPtEaw5nz6q3LRedCj+B/ByJhgWHZ8=;
        b=X41l+sevqTMIQWckTeWZqmIfn/Ukz4abdjD+AwDoziFCYebaqxZ9mdMh13Jvw8nPvL
         4JRARQUmIyBZ5Qj3tPbzv73PWZASrTRE3Nw6Xx4Pnv9MsFVlddChO9sRdDIoFIBext3H
         EzcL2e5lOAWqvOdavo02f2FZkX/fUKFBuWy3D5jqv5xQYhnwkxZb8Uc+kvZF0yzTnLId
         GKntvr4+2RZV42OPQu37gBSp38Z0ZyWyLrtvmRwyV3T+RC+m/zaNOFvaZi+qSoQcMNzi
         LbxO0jo1Ehn1XZt2e1g3oUK88FgsGyUta/qFZrJ7qPhcwUU9VyNsrXfC7akYAyTIHaIQ
         0o+Q==
X-Forwarded-Encrypted: i=1; AKwUvBwd1A8yt4oKFNEeILNCKrtLl46muvdd2TG7VKJEj+jSzbBlex4LOCteJkJEavSbrpl4NipJY/HUCQig@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3sxQWrqjLzIEV4u8TsuH8PEIHOkbAxxDeClmUdh9X0I+FVR2v
	PXXV7dA9aLx6N3mkus2j1N4FLJrm76DZDuqEbSecJ33rCXdv1sjO14Pv13t4fw5EI3TxKjMByns
	HShczHUJGAaTp/1My8vMLELvLmhAuUMR+b9Y7b9ftpA==
X-Gm-Gg: AYBFou2QSDlmmX7HfzA0bjnou1ds9T9D+qLcHEeNWS7upm8t9cJjKGZk4XvIvsjrPHn
	p7/uNCmNIjPBoQiHIQzUGJbmeSoGAczhVVF6Nfs1mhVJiyGvAPxwC50rHVCs9ysF+SoheAoQCwH
	mq3nPnt7Kteowy+Q6aicloNqGGPd0Y/Ld1q19Bl3q2WOPFINoUcirUru2MktibgWKZ60NUj0N35
	cPvLOANXpeenLKbPdSKOt4yF5JLXC10kvaL5u9RpZplNDWdS5TfE+23OxKald3bJ7a7fO0F6CPU
	5/s5oLqU68ZTqd19h8jmqzrxqj7ScuyUcAyFFmYj9WSwmYVWBYfWe16sxBrXuld6oIhgozMTEKo
	b6t13j8FW19rgFl6BHTRq/RfxNZHi0jD1W3HPtsS+vdWaXI/jTrOBXeyrXYt6sW5E0ve38oM=
X-Received: by 2002:a17:907:8687:b0:c46:d493:47be with SMTP id
 a640c23a62f3a-c49d123892bmr163688866b.19.1793263602434; Thu, 29 Oct 2026
 01:46:42 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028-biwin-tua-quirk-v1-1-767a12c9b9cc@flipper.net> <96f75e1f-9b4d-490d-9492-e60bdc31ae79@acm.org>
In-Reply-To: <96f75e1f-9b4d-490d-9492-e60bdc31ae79@acm.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 29 Oct 2026 12:46:26 +0400
X-Gm-Features: AclHuK_iIuXyc87PtXwJzKHpST6z2LbPjP651cuL9m3vutOTuWFnAaQm9CNolb0
Message-ID: <CAKTNdwEStLNtK+UGqLK8ZY42Ui5vVMK2XRu6-bsfkW3D4ZY76g@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Clear power-on UNIT ATTENTION on BIWIN devices
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, 
	Stanley Jhu <stanleyjhu@google.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 10:40=E2=80=AFPM Bart Van Assche <bvanassche@acm.or=
g> wrote:
>
> On 10/28/26 5:54 AM, Alexey Charkov wrote:
> >   drivers/ufs/core/ufshcd.c | 54 ++++++++++++++++++++++++++++++++++++++=
+++++++++
> >   include/ufs/ufs_quirks.h  |  9 ++++++++
> >   include/ufs/ufshcd.h      |  1 +
>
> The quirk has been implemented in the wrong layer. The right layer to
> implement this type of quirk is the SCSI disk driver (sd.c).

Thanks, Bart. I'll see how to redo it at that layer and send a v2.

Best regards,
Alexey
