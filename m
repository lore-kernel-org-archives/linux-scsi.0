Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C09B10A0C
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jan 2024 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eByHxQ8w"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40d8e7a50c1so1607295e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jan 2024 06:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704204198; x=1704808998; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0CVBxN2b445a133UsX9oSFJ3uLxcIkQQRN4TgJGk7Uk=;
        b=eByHxQ8wOl9WZcJ7Pv7ahmAunXdTVk03U0u0YFoXOgjkF/Wmxyht41vWR3qqMZOD7Z
         j2BcpzRIutbfMi+RIbLC3ZLusmH0I3SQyX2lLLvz+WBhyetYQMWyJwasYAbk5psC9gx9
         Vvq555bUVHbMfq+9KU1yLaCK3uOB7gySgsAdtYYXrGywAW6j8HUW3c8t0ODJamm8XSiP
         U3x5lyD7IT2tIxuqtpX2oIlHkIoOAvmxzYk+DF8me/UmdNTmOktScyZAaC+y/wzHGOyL
         s2JZAcBUn7MhyAo2k23iAXvc7TwepzKKsTM3E9zeSu0H4ZAETUP8jZTkOygJQb2+YBh7
         sG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704204198; x=1704808998;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0CVBxN2b445a133UsX9oSFJ3uLxcIkQQRN4TgJGk7Uk=;
        b=jCAmpQOAEjAxoXkMlVFwtOjBXfxlEjkT1wJqhx+YqMVAGIz0KoAJOm+CWOjGgsCNEc
         W2L7VeCOoxvokU03Tnn4DsCdpIgseBCSvQVSeSg02Gho/03KEm08f1TwE5iMFQ5cm+9S
         0fYZuDkfXOwoYpNw5Lrahg4km7AJunEj6jYeMxM+VjeGEc4nAIvPWEt5YgtM0UvdN4jX
         jeqXt38mZ/Gx/VEV3Yi093YVqugX3QgGLgnjuz1v1VhlSGiXWd6yIhshChFpBExbzyzt
         S91tAoyTeC+tY7U2vNkk+XMbR558REIQgSrj1N4J0WwnRqZQKwTlXNloWXB47K1WOFK6
         5prA==
X-Gm-Message-State: AOJu0YwRDdGDgXsK0MrOaNhDGM+vZskBVRG6nsnK1cb33Rs0DKXWprCg
	CbRPiMxgRInGvT6j78CDaLVnLIk9aDvvGw==
X-Google-Smtp-Source: AGHT+IFOvGdhleRJ7ygZH57lI+Ub0PS/a2HOI+3RC24eb3xIU+LiPD60rC6vDreNFBwusmS/M0we1A==
X-Received: by 2002:a05:600c:1912:b0:40d:554a:f604 with SMTP id j18-20020a05600c191200b0040d554af604mr6587352wmq.34.1704204198505;
        Tue, 02 Jan 2024 06:03:18 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id z4-20020a5d4d04000000b00336a1f6ce7csm24023808wrt.19.2024.01.02.06.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 06:03:18 -0800 (PST)
Date: Tue, 2 Jan 2024 15:58:06 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Justin Tee <justintee8345@gmail.com>
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>,
	Justin Tee <justin.tee@broadcom.com>, linux-scsi@vger.kernel.org
Subject: Re: [bug report] scsi: lpfc: Add support for the CM framework
Message-ID: <543d02e3-8208-41c7-836c-3c52bd598158@suswa.mountain>
References: <121b7df5-8277-497a-983a-eac00061fb58@moroto.mountain>
 <CABPRKS_8MuDTA3oTXdt+ib_Zaba1iD3xN5ZZFM7fOAFCDBFj6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPRKS_8MuDTA3oTXdt+ib_Zaba1iD3xN5ZZFM7fOAFCDBFj6A@mail.gmail.com>

On Mon, Dec 04, 2023 at 11:46:28AM -0800, Justin Tee wrote:
> Hi Dan,
> 
> Line 8301 sets sli4_params->cmf equal to 0.  So, “if (sli4_params->cmf
> && sli4_params->mi_ver) {“ on line 8338 would not evaluate to true and
> we would not reach the line 8343 in question.
> 

Thanks, you're right.

regards,
dan carpenter

