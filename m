From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 00/04] scsi: scsi_request_fn() reimplementation
Date: Tue, 12 Apr 2005 20:01:38 +0900
Message-ID: <425BAA92.7070209@gmail.com>
References: <20050412103128.69172FEB@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262313AbVDLMDg@vger.kernel.org>
In-Reply-To: <20050412103128.69172FEB@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
>  Hello, guys.
> 
>  This patchset reimplements scsi_request_fn().  All prep's are moved
> into prep_fn and all state checking/issueing are moved into
> scsi_reqfn.  prep_fn() only terminates/defers unpreparable requests
> and all requests are terminated through scsi midlayer.
> 

  This patchset assumes that previous patchsets 'timer updates' and 
'clear REQ_SPECIAL/REQ_SOFTBARRIER usages' are applied.

  Thanks.

-- 
tejun
