From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v3 2/5] scsi: replace "mq" with "first_chunk" in SG
 functions
Date: Tue, 12 Apr 2016 13:36:53 +0300
Message-ID: <570CCFC5.3050807@grimberg.me>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
 <1459806491-16428-3-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459806491-16428-3-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org


> From: Ming Lin <ming.l@ssi.samsung.com>
>
> Parameter "bool mq" is block driver specific.
> Change it to "first_chunk" to make it more generic.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
