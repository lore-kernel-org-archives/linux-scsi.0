From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Wed, 27 Feb 2019 09:50:08 -0500
Message-ID: <yq14l8p9tgf.fsf@oracle.com>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
        <d0672a75-2900-5f6b-368f-5808914322a8@suse.de>
        <CAK=zhgpuB9Y+Z1e64D1Dm4fJtJ2rjZPf5g_TLNwnKbauRpqrJQ@mail.gmail.com>
        <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de>
        <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
        <0dfb09ca-8723-3a3c-a6a8-c643856c57e3@suse.de>
        <20190226143313.GA23865@infradead.org>
        <6f94a905-45c9-4a77-bbb6-9669197e8d8f@suse.de>
        <CAHsXFKGbNfJ32EE_Gyz9yC0k+yNB=rgMQZc+jAQr2nFPDC+oFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAHsXFKGbNfJ32EE_Gyz9yC0k+yNB=rgMQZc+jAQr2nFPDC+oFg@mail.gmail.com>
        (Kashyap Desai's message of "Tue, 26 Feb 2019 21:35:10 +0530")
Sender: stable-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kashyap,

> Primary drawback of using "blk_mq_tagset_busy_iter" is API is only for
> blk-mq and it is not available for all the kernel with blk-mq
> support. We have seen multiple failures from customer and those
> kernels does not support blk_mq_tagset_busy_iter. In fact, blk-mq and
> non-mq stack is alive in many Linux distribution and customer is using
> those.

I'm afraid the burden falls upon Broadcom to manage enablement patches
for older kernels. So the non-MQ/non-tagset-busy-iter cases are not
particularly relevant for the discussion here.

Let's focus on getting some usable plumbing that drivers can use to
abort oustanding tags.

-- 
Martin K. Petersen	Oracle Linux Engineering
