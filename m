From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v3 1/5] scsi: replace "scsi_data_buffer" with "sg_table"
 in SG functions
Date: Tue, 12 Apr 2016 13:36:25 +0300
Message-ID: <570CCFA9.4010902@grimberg.me>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
 <1459806491-16428-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459806491-16428-2-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

> From: Ming Lin <ming.l@ssi.samsung.com>
>
> Replace parameter "struct scsi_data_buffer" with "struct sg_table" in
> SG alloc/free functions to make them generic.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
