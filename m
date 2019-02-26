From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Tue, 26 Feb 2019 09:40:24 -0500
Message-ID: <yq1k1hmd353.fsf@oracle.com>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
        <d0672a75-2900-5f6b-368f-5808914322a8@suse.de>
        <CAK=zhgpuB9Y+Z1e64D1Dm4fJtJ2rjZPf5g_TLNwnKbauRpqrJQ@mail.gmail.com>
        <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de>
        <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
        <0dfb09ca-8723-3a3c-a6a8-c643856c57e3@suse.de>
        <20190226143313.GA23865@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190226143313.GA23865@infradead.org> (Christoph Hellwig's
        message of "Tue, 26 Feb 2019 06:33:13 -0800")
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> While this is better than the driver private tracking we really should
> not have to iterate all outstanding command, because if we have any
> there is a bug we need to fix in the higher layers instead of working
> around it in the drivers.

I agree completely.

-- 
Martin K. Petersen	Oracle Linux Engineering
