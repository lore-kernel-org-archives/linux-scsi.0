From: Shaun Tancheff <shaun@tancheff.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Thu, 25 Aug 2016 03:42:42 -0500
Message-ID: <CAJ48U8Vojc=kzSbjjmM9y7DE0tCUk_GqdY_kLf+NY07VfefvDQ@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
 <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com>
 <CAGnHSE=Laj5kpFNJ-EqdN-NTUQJyOmwYtjWM7iLqGxDRqMSoxA@mail.gmail.com>
 <CAJVOszC2sp0=GA02ZB00s46F84XfU7DvzNSravyhbjxY651ozQ@mail.gmail.com>
 <CAGnHSEm18o-8ZRhyFnyQ22rUm+gJLWwJyxoA-iSJnkM3k4oHHQ@mail.gmail.com>
 <CAJ48U8XDb7S2WPSDBtn+VUoRb70u6SmgbPFhm-NC2jx6CmE2mw@mail.gmail.com>
 <CAGnHSEn470B0ecDdMSY29W4Or3jD_NPoUAku_09o=X9Tn6vSpw@mail.gmail.com>
 <CAJVOszB7cyUcE+A_EUw0OnvdO3iGFW9sG45R2Ng1Ea_Q7YxaQA@mail.gmail.com>
 <CAGnHSE=Lsb-L-nd8OHQpVPDe1JkURjnXoA26ZQ7bH1GBEPAAtA@mail.gmail.com>
 <CAGnHSEmZdVy2Xp_wK8n+89mD18NPAqcy5UBhhDEy5RAAC7c+vA@mail.gmail.com>
 <CAJVOszBcuNouJk28nr1smPYJfEhE_9LjD0UgOiG31ApgrXzGJg@mail.gmail.com> <CAGnHSEn3d7s3Tw9MT9Vos+0QBRnnj_gqKorcC56SzOxkK5NN-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37583 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933608AbcHYInk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2016 04:43:40 -0400
In-Reply-To: <CAGnHSEn3d7s3Tw9MT9Vos+0QBRnnj_gqKorcC56SzOxkK5NN-w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Shaun Tancheff <shaun.tancheff@seagate.com>, Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tom,

In my opinion this patch you submitted is simply making the code less
safe against a buffer overflow without a sufficiently good reason.

In future please comment on other patches as replies to those patches.
Mixing them together is just confusing.

--Shaun
