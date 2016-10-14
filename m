From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 16/17] lpfc: Fix fw download on SLI-4 FC adapters
Date: Fri, 14 Oct 2016 12:44:31 +0200
Message-ID: <67fda4b5-547b-67c5-333d-94107680afb5@suse.de>
References: <58000559.ask9jYTwRrGrLPVO%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48643 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752221AbcJNLdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 07:33:46 -0400
In-Reply-To: <58000559.ask9jYTwRrGrLPVO%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> Fix fw download on SLI-4 FC adapters
> 
> Driver performs a quick validation of magic numbers in the fw
> download image. Driver needed to be updated for more recent
> magic numbers.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> v3 mods:
>  code cleanup: parsing image header fields
> 
>  drivers/scsi/lpfc/lpfc_hw4.h  |  3 ++-
>  drivers/scsi/lpfc/lpfc_init.c | 20 +++++++++++---------
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
