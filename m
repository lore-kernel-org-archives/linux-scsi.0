From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
Date: Thu, 9 May 2013 08:57:49 +0530
Message-ID: <CALMYJDuj9SH8isLD-CjOivBAGE80P85KkUTErki-PJFXH3Scgw@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com> <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <002401ce4bc7$cda068a0$68e139e0$%jun@samsung.com> <CALMYJDtFA9PTu++4ijuUujOU=N9Sw=+=pH4KpTCVqLQmL6uE7A@mail.gmail.com>
 <000201ce4c58$e3bc3b00$ab34b100$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47097 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3EID2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 23:28:11 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik5so1215908bkc.23
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2013 20:28:09 -0700 (PDT)
In-Reply-To: <000201ce4c58$e3bc3b00$ab34b100$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>

> There are two patches remained. These are applied with your final comments.
> Do you have any idea?
> [PATCH v4 5/6] scsi: ufs: add dme configuration primitives
> [PATCH v4 6/6] scsi: ufs: add dme control primitives
>

Since there is no use case for these implementations yet, except for
ufshcd_get_dme_attr_val(), as per James's suggestion
[http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg20207.html]
I did not ACK the patches.
The same patches can be used to implement related features and resubmit later.

-- 
~Santosh
