From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 03/16] lpfc: minor code cleanups
Date: Mon, 13 Feb 2017 09:17:18 +0100
Message-ID: <e5172378-b70e-75ae-3818-d92a8430414c@suse.de>
References: <58a0d91b.VLyGPk7S2XWliQJD%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdBMIRU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 03:17:20 -0500
In-Reply-To: <58a0d91b.VLyGPk7S2XWliQJD%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> This contains code cleanups that were in the prior patch set.
> This allows better review of real changes later.
> 
> minor code cleanups:
>  fix indentation, punctuation, line length
>  addition/reduction of whitespace
>  remove unneeded parens, braces
>  lpfc_debugfs_nodelist_data: print as u64 rather than byte by byte
>  covert printk(KERN_ERR to pr_err
>  small print string deltas
>  use num_present_cpus() rather than count them
>  comment updates
>  rctl/type names moved to module variable, not on stack
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
