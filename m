Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EnsrM9Yt"
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31C2100
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:58:46 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3b9fcb3223dso4444690b6e.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702529926; x=1703134726; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M/eDbBnSAkVRJUrxqWp2z02YHOKbVeP2jj9zgSj9Xq0=;
        b=EnsrM9YtjgUetkpf59lJhmRG1lSG0q3gUnrjecsuAGyHIH4cCBgamD4rO6c7oQUrII
         dFFRiuvKsvS3XIGEm8SVbgoLd2zNF2aSfCzvYD42W75BdP6inzOQZxWM4kNB3Um/zCvv
         I/UZeELcCUWZ8j6VKZgimMXVokcOjGruzqUjcTOcfe3QAo4x6lA320cmUXIlHHVgENCG
         j4jpBoQEGzauCQxdOgj4drFtl87ORy7hbZ3xekgBVDX60MHuivcHfBkIjvlBsUXPlm3G
         +MGqNeMcrMjyd5z07bsXhPyLa92ll9m9v1kWmJofQFJnVAnBfnYoNGH1Lrq6amhzqJ7W
         9a8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702529926; x=1703134726;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/eDbBnSAkVRJUrxqWp2z02YHOKbVeP2jj9zgSj9Xq0=;
        b=JZyJ3tSU9TIshFStAhfpaMNmbcVShZQtj/ZifsvT3qbWp2LLCZySmBA/biWpJqCUzP
         ShRdywZQPGqe8i4QNYpx1fHIApnYxL+K4wL5a3K6gybAJ5qnlEsM7+s2VyumXWIwl5HZ
         sVwNEE+Ec/ZzyzjiQjSgKCniAnP22JiZ7TN7YOScWqRhIApoWsRxwXpwsdfuwv7XRIgW
         wbV2ibJWPyjmnuUr/jCj6cn0uYyBXVr1cbSWarZnolXjokuq5Z1Zic8GD/aqHn/jtODD
         WeLShHQxZ60S2dalo2gvoAt0LOEyxyGhAnEKEVWdTT6k21Zn9KMm8zLU4jsVYwczQhGm
         +r9Q==
X-Gm-Message-State: AOJu0YzZ56H/CJvZe69AwxuRw4TQ4IH/jyNmjTwVq7BtKrZe2kC9Krjv
	BqFdVP+7K10ZBqXuQzo9jezR
X-Google-Smtp-Source: AGHT+IEsGjbaCX0celZ3IskU0RM8rY0gp0k/KHnbnZcAJOW0IfN7a0QoV+GxEx1NCpC9se2uHBGbng==
X-Received: by 2002:a05:6808:1509:b0:3b8:5fec:5d6 with SMTP id u9-20020a056808150900b003b85fec05d6mr11796197oiw.27.1702529926128;
        Wed, 13 Dec 2023 20:58:46 -0800 (PST)
Received: from thinkpad ([117.213.102.12])
        by smtp.gmail.com with ESMTPSA id c14-20020aa781ce000000b006d082dd8086sm7041845pfn.214.2023.12.13.20.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 20:58:45 -0800 (PST)
Date: Thu, 14 Dec 2023 10:28:39 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.ibm.com, andersson@kernel.org, konrad.dybcio@linaro.org,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com,
	ahalaney@redhat.com, quic_nitirawa@quicinc.com
Subject: Re: [PATCH v2 00/17] scsi: ufs: qcom: Code cleanups
Message-ID: <20231214045839.GB2938@thinkpad>
References: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>
 <yq1zfydfmqu.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1zfydfmqu.fsf@ca-mkp.ca.oracle.com>

On Wed, Dec 13, 2023 at 11:10:41PM -0500, Martin K. Petersen wrote:
> 
> Manivannan,
> 
> > This series has code some cleanups to the Qcom UFS driver. No functional
> > change. In this version, I've removed code supporting legacy controllers
> > ver < 2.0, as the respective platforms were never supported in upstream.
> >
> > Tested on: RB5 development board based on Qcom SM8250 SoC.
> 
> Applied to 6.8/scsi-staging, thanks!
> 

Thanks Martin! Andrew spotted an issue on patch 16/17 and I'm going to submit a
patch fixing that. Please either squash it or apply it separately at your own
convenience.

- Mani

> -- 
> Martin K. Petersen	Oracle Linux Engineering

-- 
மணிவண்ணன் சதாசிவம்
