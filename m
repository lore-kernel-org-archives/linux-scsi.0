Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D8A71747;
	Sat,  5 Apr 2025 15:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743866754; cv=none; b=Cv34a+TG1UkrlVf50GHHbqNAQi/2JYguRWA6z9b4WInpEJQns2pcts9nF2yCqyEGGFGRdg3P48ukygQbbg3rYuWZTUe2Lhc3Wzmp7KOKPrjVKhVexJfxLstDL2BF59vhUqQJsswyk4CrLXjJQekMCvWST3Gw3F7dWaS1Avu3ZVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743866754; c=relaxed/simple;
	bh=h3GhfBIiVRF/Pd3aAJkjlB+5zHbq5qv4N3L5/N+zLiM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvvafGH5T9JtKAdlqkmpkPUiEJyALvmDp0vepsWwfcDmrfnrll9aCtmeCVhUr9PuH+f63plUxGZqJ/lepQ89sALvCP5NNcqcj2tZlb8INyLG2bRNmJrEmh8KLJ2N2fH/LcXNbFkeUBeBf5dpWxdfJmPHU6Cvtb4wUBrsW/u7eHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUb/gVZn; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUb/gVZn"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d07ca6a80so15409535e9.1;
        Sat, 05 Apr 2025 08:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743866750; x=1744471550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4rYQcQMBl9xOlGSmouhghPZmgfZgiwJh9mi25o4o0Nw=;
        b=BUb/gVZnYPLhA5OyXM7YsnAU0KmjS726XXtBnD5UKj25w7yJvptuZV1WG7SX88EpaW
         EqGY0LTVEn341Atj6+UJycIZFdNTuZFOEWSLMVeQyZHWewsi1QAwNJVOl4WYtsm1nSJ3
         5ua48qjviu0WMZjbKVnLpfAFJSfWmOVxSHWBhwWCFebkmfbAv/EA1T5fWSzWHDQOMS8T
         /ieugtAMFoMj1H2gt3d+lHgEjH9irN8CHwPm5N9fRJFk8lvSV1L2V+tgcyyOCdZ/mJqh
         RDAfd35aIX6GNtqMVHz2qI0kydiH7MByFjcnZljlz8E8Gt/2xZkjWQ/4jsu6nbRXk5sy
         BfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743866750; x=1744471550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4rYQcQMBl9xOlGSmouhghPZmgfZgiwJh9mi25o4o0Nw=;
        b=plKUeNma/9Hk5hh7yZe5ikMuzjAKhn5LiDiLWSzMKDy1k5yAYMaL09x40B1Y1aFcys
         jMu6XQvhyCnVoObsBCBJyvvooOhRqoSsC+BIjkf1S0fiPXc1xN8Ic6yiUyLWmVrjkBrc
         OtQaju9qr1p71PxXFsQLkmtEl87P+RreM1VPQEaMiWyzCjvmA0oHktF0ZkyCzWm25igE
         0S+T/PDfdjpOGHmH9+tet9ufBtFty9r1IXvZ9gPvM253B6VLnjYMQRqrFwNWenE1EkCK
         v4/pHuroohNFF4cFDTMMP+/UgMhl7WiJCNGp7fF0XebrkdhaCa6JqH1Vz7/YhUoONLR7
         ctBA==
X-Forwarded-Encrypted: i=1; AJvYcCVPBugbQ4+TAlSMitSBRHGFXIJe445+VFaKGb+vxa7Jg6cAIJ/9ToOogsueD0HFfqDSTAiJFThQX8Q84mtc@vger.kernel.org, AJvYcCVfNfdHi4sx1wb40uENI0mDdGK9U9UX4FSgy5cXHhNb1ZilUl+bpNxydkeJx3nJl+LcvEyc7oT+2pDQ3A0=@vger.kernel.org, AJvYcCWT/lckKlSUuX2gFBMEw29Mu+Fe4AY4UDyKIFZpjwwx5H/qXSaLztR0IMz/wR2pWe102NyRH9PCKwfRng==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5wUabVYAJAeLZ3mAGArdFHlt0q3R5nNHDVTqYeVDRPgECZfaF
	tgaTVng96UPX8HvOWoVQrWWgl2lXLD0dFKtO2d2lrr+/Xcf41AWA
X-Gm-Gg: ASbGncvcbVUcceRTL/YF8m8IYrXVROmfjKmeCi6bYU2p1uKPOSQfFH67ROtcF+Ch+TB
	jqSof5i07bp5Hux+SjITIPakrrhsU/fv9A90NkGoeIezM1Mle9mqYKUWk1AmIgCp6dTv3FqG+zj
	3D6jd2OSpHEtXAFh0yIE9w0Q30CrFpb7g6j7uTal2QH/WeICnq8+QsRDwffdwVi/fYTFvRu1svq
	R6GRld5kCQxJR7v2Mvk64Ov7SblW0Fpe3ipKsb/n5venD3sSYXmu6iKQIPl5oxctAFxmsiZWfxt
	eZPkHyPikRomAM/ZmJqzamCltj1iV6IgIradK1s2p78VrS+CHPMqwNfLV9W51J5ab77Fffq6TJS
	TuXrNanM=
X-Google-Smtp-Source: AGHT+IHP3tRbXf7i8RI1670OlH08T8lHDdFW9fMLv8Xn/kEmEaNz4d/F/FiflXkACwCWZkgl8ZM6+Q==
X-Received: by 2002:a05:600c:8719:b0:43c:f85d:1245 with SMTP id 5b1f17b1804b1-43ecf8e7321mr76664845e9.17.1743866750233;
        Sat, 05 Apr 2025 08:25:50 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec364c959sm75438015e9.25.2025.04.05.08.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Apr 2025 08:25:49 -0700 (PDT)
Date: Sat, 5 Apr 2025 16:25:48 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Baris Can Goral <goralbaris@gmail.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH v4] scsi: target: transform strncpy into strscpy
Message-ID: <20250405162548.310dea37@pumpkin>
In-Reply-To: <20250405143646.10722-1-goralbaris@gmail.com>
References: <20250402204554.205560-1-goralbaris@gmail.com>
	<20250405143646.10722-1-goralbaris@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat,  5 Apr 2025 17:36:47 +0300
Baris Can Goral <goralbaris@gmail.com> wrote:

> The strncpy() function is actively dangerous to use since it may not
> NULL-terminate the destination string,resulting in potential memory
> content exposures, unbounded reads, or crashes.
> 
> Link:https://github.com/KSPP/linux/issues/90
> Signed-off-by: Baris Can Goral <goralbaris@gmail.com>
> ---
> Changes from v4:
> 	-Description added
> 	-User name corrected
> 	-formatting issues.
> 	-commit name changed
>  drivers/target/target_core_configfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index c40217f44b1b..5c0b74e76be2 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  	}
>  	filp_close(fp, NULL);
>  
> -	strncpy(db_root, db_root_stage, read_bytes);
> +	strscpy(db_root, db_root_stage, read_bytes);
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);

That code is broken, it reads:
	read_bytes = snprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
	if (!read_bytes)
		goto unlock;

	if (db_root_stage[read_bytes - 1] == '\n')
		db_root_stage[read_bytes - 1] = '\0';

	/* validate new db root before accepting it */
	fp = filp_open(db_root_stage, O_RDONLY, 0);
	if (IS_ERR(fp)) {
		pr_err("db_root: cannot open: %s\n", db_root_stage);
		goto unlock;
	}
	if (!S_ISDIR(file_inode(fp)->i_mode)) {
		filp_close(fp, NULL);
		pr_err("db_root: not a directory: %s\n", db_root_stage);
		goto unlock;
	}
	filp_close(fp, NULL);

	strncpy(db_root, db_root_stage, read_bytes);
	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);

	r = read_bytes;

unlock:
	mutex_unlock(&target_devices_lock);
	return r;

'Really nasty (tm)' things happen if 'page' is too long.

	David

>  
>  	r = read_bytes;
> @@ -3664,7 +3664,7 @@ static void target_init_dbroot(void)
>  	}
>  	filp_close(fp, NULL);
>  
> -	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
> +	strscpy(db_root, db_root_stage, DB_ROOT_LEN);
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>  }
>  

