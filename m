Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794937733;
	b=D2xUNd8sjF5o29D9Vf4/4Riw9VVH85MAxhtiToNHr1XCT2GfOLoDnNSesHfiCYcVkhT0
	 ooBgjLUiHtWbc6Uar9k5BmHnjsGynmHdt/NQBFLMiK0H4p8/RmqgykiUNOVXlA6nwSJ8j
	 KRaRBjj60ex0iYnKMWgRT970VdDt2GfwtAQaXHu6AgCL3zzJrYMUiy/zMRhXQzfGM/omW
	 eYYYjFaAzZAMZFCWsOXrqIGOW0M1hKgd4qjaY5aUdtpqs8LRBte5JPz0nyPg3sJxQpwUz
	 8omvChKE+1ziI3QVD4+QvIlz1EXkLhV0MT6zlJrNIDNal3Nx1u/B35YymyY3Wxc3nnA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937733;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=QeImNSoFQjPxcggaJELITP7c9YTshF8TQbb95CzBw0o=;
	b=nbs42ILHd93H7GmvWip8lJDbJbk2UxgSvb3XSraFyes7iKbMP+FPMytrDziIGfWiT6LO
	 dJ9ibig3IQWjTKMIj6x7JnIYH7NoGD2oRhoAYgtcO/VcwsBlTC+XyuhVm26qeJHx5oeWz
	 CTpOjTo5cGIRQROBVnPxVYU0Ak7vmes31qXbdB9rqzoM5lyXu2RGpgWcfTTARe2Hc34IK
	 YSz0rfVFlRlm/SBqTZcwIm2Iy/fvPWRDMg/mo6JgMWfhJJKfPA0s1ymkM0k9X8S+mGahd
	 WljdnDSkwpHqfNrLmnVp5RZRYI7qnPVISUJ6meuGC6aOyB5ZPMuln6vyAUkcNqOwC6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="MA0TBMr/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C63606A331
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 17:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05C63606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MA0TBMr/
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1b244fb7fffso103610c88.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 09:48:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794937732; cv=none;
        d=google.com; s=arc-20260327;
        b=cPdp7nZGC0ceB2J34/5ZYKkwNLdjsYh3XSFIxWP7QG2REMVh/BTjxrO2EqXmddvROA
         aOX/7EdDU0TNWBinruA7Bd4OoEk67e+EagCJ1rPnUiP7XmZnhu2YpkmO4F/xVdlzk20p
         n6G0CKxHrjMCjQaXQDc2DBg/NgLYjEoyb11J+rIHn5ZeT91FD4RPaWuvt2hhDFhMuCpl
         Qy0WQBUeqC/8wuYwq0WZfXHiyLE0Ds10Fw30XqGRquBywT4jdFdmw+7/eqrgzHUlEDeD
         34L3NNJmypXQ2AuveWI7KZVqRVNOrvfJPSnbZXfnnua50yHf8+RSUTQt3htayHdt3Vae
         BNpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QeImNSoFQjPxcggaJELITP7c9YTshF8TQbb95CzBw0o=;
        fh=J3dD8zTZBhwA22Cz/PB9fzCXoQK8rXyeTa66nJBwXsc=;
        b=nV7uIGFktKtGuClR7dNflLNQxQd+j5EkZ+ngWq0GM3Tc0x6u278HM4WtzesaP9aUPs
         jQgQjs7e9SEmKcfdXhRl1QYg13Db+Db6q6rEo0wPuAHA/dO4envBxvNwiARjBbDxaVoR
         PwGA/zoAhf02uxFunbAKMhUOqyc0WfWg3PUY5x7j5JCNGOy7DZCyALDDswaGJqeQIoYm
         SwjPeU97b58JPabzczc1vS3sOn1lYXxVxoxBAc+dpJAr/3JoASRA9wV+gxVwG+d5tLhv
         ETbNI/lzEy3SjI45pX4Tzint5juIoaXtSdn47dVmo1ZNd6YiZnEmTEiykwqLQzvfDjXz
         VhMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937732; x=1795542532; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QeImNSoFQjPxcggaJELITP7c9YTshF8TQbb95CzBw0o=;
        b=MA0TBMr/BbRwKo3vXwtxqALGCCRST1ayS2R01xrDHlY21z0cfgrNZc/moCwTLWSb0B
         XvL74WFfhiJLiRbza2+eE9pjYiQNwmVi6zER7CbYZVM1kKSXndGTwxFnmgcHJd/bmDIO
         L6/gYoBQX62hF5b8+TmCGIgnR1nAZFA+pmeE6PVHsin3AlC7pewyUk57wdFmPzUQcrZL
         s3Y9JOB1qmV0AHr4ApNqqsc9kqcBRwBxtV6Qcaxg/mV2w2lh5sHIr9JE9IzQ0hqQNG32
         ER7BawyWVLL0ovA+AZOArS7XwnUVjAdL4t/IaBntRfSqHNVY600aKPD0Y9NnBvIpqGmM
         BGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937732; x=1795542532;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QeImNSoFQjPxcggaJELITP7c9YTshF8TQbb95CzBw0o=;
        b=M91kT3RgbaUEx0Krpsag5ZRUnMqN5ITtTOf0voxRNPLNMI5ngDAp/SL+Z2rMyKxrTM
         2p/NuPZixJPLCmDdI55OMaJ6XcjJPztQrUMFLNNgn5jCI2qCrVex7YjYtnrRnIZiH5MG
         cLckrKQM2b0K6p2dVBbxcQ4LrxRIO/xxuyAGvd2AtDjxdcnSVGGCJIwNqYworciLZMba
         XOaoilQtl5dub8nLgqWvJhW/sYDpd94gq1rMO32FyXmPRVTN6HqOnfAF75NSdwQHCPhe
         e/S6Z4S9MrqwPO82rNg8ouLmb9Gzk+Uc+LYYTT/aBk5K7AsNkyZFgtTEMJkutAHoMAKr
         FoYQ==
X-Forwarded-Encrypted: i=1; AL+hErFTSTbD5EgInFKSEHCVynrRZUcq2sFXemlDIZ4uOEK1EJDEQBnrFiqsaoE+BTPUZG6jXm+uaZdPOIZj@vger.kernel.org
X-Gm-Message-State: APuU4Z+VJh9m/PpVw2oUyLehR5w8koVGY+1NqQsxahdyItW1oVfSspJ0
	73ZKxKwPPUvqOq/RVTosRfCRag1W1dC+1C5rk70EMB2cTg7107+ueWdBh5Aw1An8CVQvr2+9j0u
	7M2LplSu3oTo+TGxVcfmWAqQjCouHkV2jyH+PoXHS
X-Gm-Gg: AYBFou28hAhSrjdTAB+2P9CH0PxdfK0MYLZL+8M0/Wjq4alP5kx+peOyCUKPDxHU6Xm
	PQe/saYHOM14y6UpzNKHMJ06NxxEieP/20Pb6vF19X454NjLiCGRrVpgdg6sGKwduX/o0Qzx3rE
	CgOqYI0iIr2z+v4sCU3J5wpvGVkUPjJ5nIIyIvmXUqgYseDB76zD87vOnS5+L2HExyuS7dAWYRJ
	vLLR+Yq+fdkx6yHntSDMv5+xNu+pxU/eFAAblXiJf57eKzPKBpWM5OfTroQb69xRiJjDpnCB4za
	VfIGU69nGdt7oUOvV9i5XtB1ipEsw7BRvk48U69B6uYAhJe43cJVBqILsGDBurSNBb/PCZOqyGy
	7aVs6HP3T6JsVOsAZIpiwjBunppHKbffZn/qTxj6QYJP4byq9uERCZ/KWXHAgwK+2zOqbMh+oLe
	+iRXRpm9NIy9s=
X-Received: by 2002:a05:7023:d0d:b0:151:2e62:fe8a with SMTP id
 a92af1059eb24-1b543d0cbbemr278336c88.40.1794937731249; Tue, 17 Nov 2026
 09:48:51 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116224811.3362188-1-tadamsjr@google.com> <1401d9ab-4075-46fd-8a99-ed818762bb1a@acm.org>
In-Reply-To: <1401d9ab-4075-46fd-8a99-ed818762bb1a@acm.org>
From: TJ Adams <tadamsjr@google.com>
Date: Tue, 17 Nov 2026 09:48:39 -0800
X-Gm-Features: AclHuK8DUWVfohtoo3OuXqVpuNGoNl8loZSKlafAOSespKxNsS6LWa7OKmIxN1s
Message-ID: <CAL54JgcvZodLtJkPEgD557RXgJ6_HdaORaHeRGQopOx0ULvm-Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Offset hardware queue index for MSI-X pre-vector
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, John Garry <john.garry@linux.dev>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 16, 2026 at 3:04 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 11/16/26 2:48 PM, TJ Adams wrote:
> > -     return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq));
> > +     if (pm8001_ha->number_of_intr > 1)
> > +             return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq)) + 1;
>
> If "1" in the above statement is not changed into a symbolic constant,
> it will be very hard for anyone who reads the code of this driver to
> determine where that constant comes from.

Good point, and thanks for the feedback. I'll send an updated v2 patch.

Thanks,
TJ
