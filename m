Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C8192B7B;
	Fri, 14 Jun 2024 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382369; cv=none; b=dxG5xxkW1Alhyq9XZJdyEmZ1+Qn6K4xM2WICXZM3u0TzqWmR3RhNTZIQicpPODij0CBI+nPIi1Bef6qi2NJxErXddjv3QpNYFOJUllrSAJ8cZaDl+btTpdGCZI5InIcdMYaJ2a/dft2AHW0nrdbrdeHKmu9xlRbDOkdyFKh2A0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382369; c=relaxed/simple;
	bh=ayg07pF7euQv/CPhXKbrgipzCXGh1+VtDo0vciMqb4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CpjjKeDAEQCJR3PRXSxW7URpujdfb181jfL8138MowLpyXqTP3aM7AW9VwZPZZb4gfc4mflgEtPedtjIN5SltzXfpYkgHVNZNz06BLHXrfzI8mEv9tAyP/bcoKb6aAMK7Gb1x4QcncbzIXjtGF12Xwsr+pclQy/fsq/Dln9370A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IF8ldubh; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IF8ldubh"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-62a0809f96dso2335067b3.0;
        Fri, 14 Jun 2024 09:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718382366; x=1718987166; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLGKDZVOQ3iS6C5OGcazxokC/tYhNiWsWZ8pHrHihu0=;
        b=IF8ldubhLRsL+WU05KIo0+qJ4h1YtQI8Iix20/BZMpWjCxV0kl35bc6/3ofyPYjP/z
         Ex2BJrbja8qp1izsYk/eguxZGEotrymgB/vEOtOfeFyEed+9LsPqnAakkjN7PEJHBMXh
         kolNEy90Y5/K9XXvPl0X+jAgC33AAEBsPt5j2HB+QVF2Pfq7s4UT6kptiWO5OqaqDVrh
         yI5KxbaGcFNv2OFSsMLZqamZB5avaBuGFKVpoc0azefQpEn80P4rzcJlg4UYvYc+HWfC
         9/cWp+0/CjwDO1QgFv2iv5gT5XsKTOaYEfID5a3MrJVxS9ICaX28UO4My/OkAPFif/+v
         4LUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718382366; x=1718987166;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLGKDZVOQ3iS6C5OGcazxokC/tYhNiWsWZ8pHrHihu0=;
        b=NVv33R4ER7GV2BqaENcUtFrrzEjrwoHgaj4wF0XMv19/Ds2rDCoU7Y8J6x+tQjU38b
         ggNE0K9hHA9dQeIa1oiS4Ba0iLYCV7iwwJZFZxwVQaQn7FlJljSSchmD5sO6FgZZHXk1
         OkoLUJN7cWxuuRf5mG1P8aEjSgbboschPcDbH+Q3/j3wMzI45eAuj99cVpRfkuw5PUI5
         3CSca0o+bh3jouCKrcjyCWInMpRm1AlM8ywWDutfJcyqPuM/GcRbtEKK3qt2LKJaAN+G
         Yzs91kDB/LYOMymczLI/IHwhty8rOJUv9GWPm13m+LFvZrZviCmCt88f23jprsKSMCdA
         3hBA==
X-Forwarded-Encrypted: i=1; AJvYcCUxqk9S8khgtMTRnXQN9uYjMrcPIbPsSGHa+lm3szf3PHE0XF5acZ4sMRs+alVjQVeSpFhziXOTR/O6FyWRHoI7nMNKbQ38dfqdanMdsR3tqiioZnzssZrw4AVwVNldx/Mz0hXwKUdzqQ==
X-Gm-Message-State: AOJu0YxDkq9MRG6kpbOhvOPo/TEeDpL3x9vD1BqG92ps7Lc73z3SFJQB
	6s1Id5YpjYrtsu3tREcBihewFgkjHsY9R+5scvH4fJSX6KbzMp8J98RrXfRxGnSptJaFNWX3xSa
	xKEhbHXPIxhE/Z7LPfhHdDQ0BnyZZgA==
X-Google-Smtp-Source: AGHT+IFpX3YXCHGs47WbQav3cjkOyVOtvBNL3pgoaCNtlNCAXWBCPtzUF39Uqme38dR1sz3eJd4rv7/aTHNWqC1IsvM=
X-Received: by 2002:a25:d64d:0:b0:df7:a3c6:c849 with SMTP id
 3f1490d57ef6-dff15526355mr2617298276.4.1718382366653; Fri, 14 Jun 2024
 09:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240614124233.334806-1-qq810974084@gmail.com>
In-Reply-To: <20240614124233.334806-1-qq810974084@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 14 Jun 2024 09:25:55 -0700
Message-ID: <CABPRKS9s11TqdoYF3sxHsXAxSNwt0fK+=29amtK9XHAvb4xM_w@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] scsi: lpfc: Fix a possible null pointer dereference
To: Huai-Yuan Liu <qq810974084@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Huai-Yuan,

> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index b1c9107d3408..94d968a255ff 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -1904,6 +1904,8 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
>
>         /* Get transceiver information */
>         rdp_context = kmalloc(sizeof(*rdp_context), GFP_KERNEL);
> +       if (!rdp_context)
> +               goto out_free_rdp;

Understood that kfree(NULL) essentially translates to no-op, but I'd
prefer that we return len here instead of goto out_free_rdp because
there really is nothing to free if kmalloc failed.

Thanks,
Justin
