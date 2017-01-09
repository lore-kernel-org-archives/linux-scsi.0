From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] bfa: remove bfa_fcs_mod_s
Date: Mon, 9 Jan 2017 10:47:37 +0100
Message-ID: <e7c94bd1-75f5-8cbd-37cc-5acc4e6a5db4@suse.de>
References: <1483868475-2949-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41467 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754315AbdAIJrj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Jan 2017 04:47:39 -0500
In-Reply-To: <1483868475-2949-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, keescook@chromium.org

On 01/08/2017 10:41 AM, Christoph Hellwig wrote:
> Just call the functions directly instead of obsfucating the call chain.
> This was in reply to a patch from Kees Cook to constify the function
> pointer struct bfa_fcs_mod_s, but it turns out there is no reason to
> have this indirection at all.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/bfa/bfa_fcs.c | 181 ++++++++++++---------------------------------
>  drivers/scsi/bfa/bfa_fcs.h |   4 -
>  2 files changed, 46 insertions(+), 139 deletions(-)
>
Any cleanup of the bfa driver is a good cleanup.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
