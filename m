From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 03/16] lpfc: minor code cleanups
Date: Mon, 13 Feb 2017 09:30:54 +0100
Message-ID: <158bf3bb-4ae9-d834-e1dc-d40940a50c3e@suse.de>
References: <58a0d91b.VLyGPk7S2XWliQJD%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36689 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752248AbdBMIbH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 03:31:07 -0500
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
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
