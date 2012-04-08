From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 1/2] [SCSI] ufs: update Response UPIU length in dword
Date: Sun, 8 Apr 2012 16:00:16 +0900
Message-ID: <CAKYAXd-_VQRCVeB6TsvL17=ZfCnafcmj++HBi-xfT7k4cGGC-w@mail.gmail.com>
References: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36305 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2DHHAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Apr 2012 03:00:17 -0400
Received: by obbtb18 with SMTP id tb18so4690845obb.19
        for <linux-scsi@vger.kernel.org>; Sun, 08 Apr 2012 00:00:16 -0700 (PDT)
In-Reply-To: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, yoshitake.kobayashi@toshiba.co.jp, vinholikatti@gmail.com

2012/4/6 Santosh Y <santoshsy@gmail.com>:
> UFSHCI spec mentions that Response UPIU Length(RUL)
> field in Transfer Request Descriptor should be in dword.
>
> Query Response UPIU size is variable depending on the data
> to be read/written and the size of a SCSI command Response
> UPIU is fixed.
>
> Currently response_upiu_length is being updated in bytes.
> If a UFS host controller prepares a Query Response UPIU
> with response_upiu_length, it will result in wrong Query
> Response UPIU size corrupting the command descriptor list.
>
> This issue will not affect the current UFSHCD Ver 0.1,
> since Query function support is not yet implemented.
> But this patch also ensures against command descriptor list
> corruption if a UFS controller prepares SCSI Response UPIU
> with response_upiu_length.
>
> Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
> Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Signed-off-by: Santosh Y <santoshsy@gmail.com>

Hi Santosh.
I also checked it on UFS specification. Looks good to me.
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
