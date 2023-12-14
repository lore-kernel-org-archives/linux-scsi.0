Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="muls9Ixx"
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FE111B
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 21:09:50 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6ceba6c4b8dso6588831b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 21:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702530590; x=1703135390; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HRQN/5Gl+E+Y/YwiwR7f4dgjP1vz1MfNF5W9YJDw5ro=;
        b=muls9IxxcvhgabpJnsNRrjQqVmbLHeRx9Z19ijPtLKdd6DTHqLeN9szmdTQFEwpc2o
         XvWXG/Ug7BQ5NCowzMWQXhdGAqdRSQ36nmPSem1r+rFZ6QjmZjkKoTjzblD+7jb/p5uC
         uRil78WewuDF5wHA3/X+olXRHjfQLDe676duAZpmEtBMxC+uigAe0ZAJn4KR78fAvoNQ
         C7Cf4W7AyFuHOJNjS08euBGaoDXQ4HOkNnYB0mxGQPk+NLfLDFxl9rOPAIQ1BCdCqr3c
         SWA2IVRpgQ3eAtZJ0YE+qYtkrdo430yg5lzdw6mGQGnoXhTAI9aCXdi9xelC674BykLY
         TMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702530590; x=1703135390;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HRQN/5Gl+E+Y/YwiwR7f4dgjP1vz1MfNF5W9YJDw5ro=;
        b=mZFk8XwP98C8JPH+hx/nmQSqgxvh9MrhhbPWnjCGTB9EIvlXAd/uINiYGstBUiTj8t
         H6sg2PcHgXNqFtK+sD5TfPGRwk36VsZrHv/taI/UbK52h6fbwV6FCepEaNBIHMdfnmJq
         O8xKTNbRi4bnEpkXyT1qf3Bo1yOtHMA7hXcH/Xvnk4GoCXzH0xxkTWsSwh0jajRFnmuS
         R2QBnA8Yd5Zm98eMgFI6oHJFJSs5jGoUD9L3+KDGr52EfkA53rYmvNxK0zrwfspn/ssF
         JtmZ46Bp5uMVkxKhDmsx2kZFiPrk9hCocF3dt6bf6zZx+fZQZl65BavWfU+MQ2jcLlLH
         huIg==
X-Gm-Message-State: AOJu0Yzv3ebXZeHAwmurv/pdjctTrHHEBLdMM76xQfQOnhpB8TKC65F8
	m1TdMYnhpv16W0QgJj+5wej+
X-Google-Smtp-Source: AGHT+IFoiD3gBR12SGaJPAivjdmpPvziAoacTLgEk0cWcQakHmt7CoNZ8PQ69964IUM6048brgNieg==
X-Received: by 2002:a05:6a20:1604:b0:190:3b35:5999 with SMTP id l4-20020a056a20160400b001903b355999mr12233369pzj.9.1702530590210;
        Wed, 13 Dec 2023 21:09:50 -0800 (PST)
Received: from thinkpad ([117.213.102.12])
        by smtp.gmail.com with ESMTPSA id z17-20020a17090ab11100b0028a69db1f51sm7950911pjq.30.2023.12.13.21.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 21:09:49 -0800 (PST)
Date: Thu, 14 Dec 2023 10:39:43 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com,
	ahalaney@redhat.com, quic_nitirawa@quicinc.com
Subject: Re: [PATCH v2 00/17] scsi: ufs: qcom: Code cleanups
Message-ID: <20231214050943.GC2938@thinkpad>
References: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>
 <b2d6853e-2de7-4e12-85f8-c130d9a745a4@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2d6853e-2de7-4e12-85f8-c130d9a745a4@linaro.org>

On Sat, Dec 09, 2023 at 06:42:31PM +0100, Konrad Dybcio wrote:
> On 8.12.2023 07:58, Manivannan Sadhasivam wrote:
> > Hello,
> > 
> > This series has code some cleanups to the Qcom UFS driver. No functional
> > change. In this version, I've removed code supporting legacy controllers
> > ver < 2.0, as the respective platforms were never supported in upstream.
> > 
> > Tested on: RB5 development board based on Qcom SM8250 SoC.
> > 
> > - Mani
> > 
> > Changes in v2:
> > 
> > * Collected review tags
> > * Fixed the comments from Andrew
> > * Added a few more patches, most notably one removing the code for old
> >   controllers (ver < v2.0)
> FWIW i found this snipped from a downstream commit from 2014:
> 
> 8084 : 1.1.1
> 8994v1 : 1.2.0
> 8994v2 : 1.3.0
> 
> I'm yet to see any 8994 production device utilizing UFS (it wasn't
> very good or affordable in 2014/15 IIRC), so I think it's gtg.
> 

Thanks for digging! I was told that SoCs based on UFS 1.x controllers were not
widely used in production, though I don't know why.

- Mani

> Konrad

-- 
மணிவண்ணன் சதாசிவம்
