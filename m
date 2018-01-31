From: Scotty Bauer <sbauer@eng.utah.edu>
Subject: Re: [LSF/MM TOPIC] KPTI effect on IO performance
Date: Wed, 31 Jan 2018 11:43:33 -0700
Message-ID: <d6729ac299e153de259cb8f8af0c888b@eng.utah.edu>
References: <20180131082331.GA25888@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sysmail.ece.utah.edu ([155.98.110.27]:28327 "EHLO
        mailhub.eng.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbeAaTNV (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Wed, 31 Jan 2018 14:13:21 -0500
In-Reply-To: <20180131082331.GA25888@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org

On 2018-01-31 01:23, Ming Lei wrote:
> Hi All,
> 
> After KPTI is merged, there is extra load introduced to context switch
> between user space and kernel space. It is observed on my laptop that 
> one
> syscall takes extra ~0.15us[1] compared with 'nopti'.
> 
> IO performance is affected too, it is observed that IOPS drops by 32% 
> in
> my test[2] on null_blk compared with 'nopti':
> 
> randread IOPS on latest linus tree:
> -------------------------------------------------
> | randread IOPS     | randread IOPS with 'nopti'|
> ------------------------------------------------
> | 928K              | 1372K                     |
> ------------------------------------------------
> 
> 

Do you know if your CPU has PCID? It would be interesting to see these 
tests on older CPUs or older kernels without PCID support.
