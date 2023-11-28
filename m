Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DD698;
	Tue, 28 Nov 2023 13:49:39 -0800 (PST)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7b06844971dso194626339f.2;
        Tue, 28 Nov 2023 13:49:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701208179; x=1701812979;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FEzKKhTYua94jLSZ7tvDRFVLHmrcI2BlEiHde8UAL64=;
        b=mmwN7KdMVSYYANCbzjG8p2jSfQD1AemKgW4s+gOhnp4Ynl0pv9fxYZxmQlz0OD7jm0
         RENU91J/NQqtd+MM1dYROZMJ/t34gIjfNRm7TldsOqkS40/paz467C6+tQ+SjfN2g+1h
         0YFSXChuyqg+70xNadFJOVf8wpGHw+VSO7uMTOCESVp8N5ZjPMurDoA9GlyNtRqDsntf
         BxkpoJfhqBZsExYcPGyug4wTtZ0hrByGPHNlDuMBzGgUNueglJg9OXJISW0sUkKkn3FL
         rX4GotYEyXFTY4XMn70VF0Hr0G/KPOXZ2/ddljJYu/YlzaEcGOjCCbZYn5GBmTPjuOLK
         XuSg==
X-Gm-Message-State: AOJu0Yzq5MXDFIyTp/ZNc+Zw73HffjEFYYdQImwhnvuDXmrQ4bb935kn
	Q0CPebXE8AoLch9H9bwAMY8=
X-Google-Smtp-Source: AGHT+IFwp2G39lgv/dnL+G6BONJ+4fNXQRMfSWj5N9YRUwEChms0xiTI59QLzVIpKqd93g1g3yhuNA==
X-Received: by 2002:a05:6e02:1945:b0:35c:81ed:878f with SMTP id x5-20020a056e02194500b0035c81ed878fmr14381104ilu.11.1701208178934;
        Tue, 28 Nov 2023 13:49:38 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:1f8e:127f:6051:78b3? ([2620:0:1000:8411:1f8e:127f:6051:78b3])
        by smtp.gmail.com with ESMTPSA id o10-20020a056a001b4a00b006cb6e83bf7fsm9372394pfv.192.2023.11.28.13.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 13:49:38 -0800 (PST)
Message-ID: <e83ae04f-2d13-4869-9254-b66eded26be4@acm.org>
Date: Tue, 28 Nov 2023 13:49:37 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v15 19/19] scsi: ufs: Inform the block layer about write
 ordering
To: Can Guo <quic_cang@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
 Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley"
 <jejb@linux.ibm.com>, Stanley Chu <stanley.chu@mediatek.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Asutosh Das <quic_asutoshd@quicinc.com>, Peter Wang
 <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20231114211804.1449162-1-bvanassche@acm.org>
 <20231114211804.1449162-20-bvanassche@acm.org>
 <ea3b4046-2fe8-4fac-b170-9298f2266cda@quicinc.com>
Content-Language: en-US
In-Reply-To: <ea3b4046-2fe8-4fac-b170-9298f2266cda@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/23 17:45, Can Guo wrote:
> I got some time testing these changes on SM8650 with MCQ enabled. I
> found that with these changes in place (with AH8 disabled). Even we
> can make sure UFS driver does not re-order requests in MCQ mode, the
> reorder is still happening while running FIO and can be seen from
> ftrace logs.

Hi Can,

Thank you for having taken the time to run this test and also for having
shared your findings. I have not yet had the chance to test this patch
series myself on an MCQ test setup. I will try to locate such a test
setup and test this patch series on an MCQ setup.

Thanks,

Bart.

