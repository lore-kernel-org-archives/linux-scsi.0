From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 00/10] *** introduce quirks for UFS host
Date: Tue, 19 May 2015 23:23:38 +0900
Message-ID: <CAC5umygmgWa4O9Sj1AZ=zQGm5PPqzw=6dGtVv6U_oA4i=sj2dQ@mail.gmail.com>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, dovl@codeaurora.org, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

2015-05-18 0:54 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> This series of patches introduce additional quirks and also,
> their enabling in QUALCOMM Technologies specific code.

I've reviewed this series of patches.  I'll leave a few comments on
the corresponding emails, but I didn't see serious outstanding issues.
So please feel free to add:

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>

(Since I don't have the platform with QUALCOMM UFS host controller and
any knowledge for it, we need appropriate reviewers for those parts.)
