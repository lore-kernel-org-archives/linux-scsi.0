Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C40C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 02:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376923AbiDDCl3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 22:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356313AbiDDCl1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 22:41:27 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A07A24092
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 19:39:31 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id z128so7188058pgz.2
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 19:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g7ICeZ+KUzrxbWSHYk2MyWmFDdmVDfufhd5a329ssxM=;
        b=maYgSpzrcGMfGIXHxblnvrhzJdAzb0jfzvHS3nhKab5aoKAYvIWR5vJVbNK7bw9rZN
         tKXUmNUF0qx9+Y82+BEdaIxmtO/J23tzdJeuuzZqTLCWSKBQrjKYgU/RDOuGEhCLMzAQ
         4NKhNS6oEM8EGcF2aeQbX9q5K/LcDC2vWMMxOEMW23nSza1o2G8wQINBph5I36/myT0N
         IH3tmhn7r3tmqHMnXHDBQx0NkrkvPsYoIEy8LgArB98nz+R9S1z2zTQq3Z9BH07nG20v
         d4ll4YLKHpsUaknmDyATqi7LxjCO+EZXiN68o26oxac0FS/Gni0l119jqBK4pBTCR+8i
         1jPQ==
X-Gm-Message-State: AOAM532DaLmvzFlBn/N2ZoksozMnSJ/bCo8J3sJsU8AZVwg3qlzfPEMf
        zVQX40+2KXO/n2PGsnNTz+g=
X-Google-Smtp-Source: ABdhPJyfB+G3//7cKynlS8XvBo6jTcNjC3uSAoWkkSvTtT0HBBLWuH6U4lDL50/t5y8h1g69VWpDdw==
X-Received: by 2002:a05:6a00:21c8:b0:4c4:4bd:dc17 with SMTP id t8-20020a056a0021c800b004c404bddc17mr21857753pfj.57.1649039970060;
        Sun, 03 Apr 2022 19:39:30 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q3-20020a63ae03000000b003820cc3a451sm8711939pgf.45.2022.04.03.19.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 19:39:29 -0700 (PDT)
Message-ID: <f4dd1024-cfc6-d2e1-bfd8-c4e5f05c530f@acm.org>
Date:   Sun, 3 Apr 2022 19:39:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 19/29] scsi: ufs: Remove the TRUE and FALSE definitions
Content-Language: en-US
To:     Chanho Park <chanho61.park@samsung.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        'Krzysztof Kozlowski' <krzk@kernel.org>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Bean Huo' <beanhuo@micron.com>,
        'Inki Dae' <inki.dae@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Daejun Park' <daejun7.park@samsung.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <CGME20220331223751epcas2p1348fddbccaa989efb1cb98e3d870bc4a@epcas2p1.samsung.com>
 <20220331223424.1054715-20-bvanassche@acm.org>
 <00d101d8456e$eb350830$c19f1890$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <00d101d8456e$eb350830$c19f1890$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 19:19, Chanho Park wrote:
>> In the Linux kernel coding style document
>> (Documentation/process/coding-style.rst) it is recommended to use the type
>> 'bool' and also the values 'true' and 'false'. Hence this patch that
>> removes the definitions and uses of TRUE and FALSE from the UFS driver.
> 
> The third parameter of ufshcd_dme_set is "int" type.
> I think the coding-style doc recommends to use "bool" as comparison purpose
> not int type conversion.
> However, regarding C99 and C11, they might be converted to 0 and 1
> respectively.

That's right, 'true' and 'false' are converted into 1 and 0 respectively 
when converted to type 'int'. I want to keep the type of the third 
argument of ufshcd_dme_set() as 'u32' because many other values are 
passed to that parameter than only true and false.

> The usage of 'TRUE' and 'FALSE' seems to be written as following the
> description of below JEDEC doc.
> "A Flag is a single Boolean value that represents a TRUE or FALSE, '0' or
> '1', ON or OFF type of value."

Agreed that this is how it has been specified in the standard. I think 
that we have the freedom to use any symbolic names for 0 and 1 as long 
as these symbolic names are translated into the numerical values 
required by the standard.

Thanks,

Bart.
