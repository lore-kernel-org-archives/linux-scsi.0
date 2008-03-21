From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 3/8] Rename 'state' attribute in lpfc and qla2xxx
Date: Fri, 21 Mar 2008 19:05:05 -0400
Message-ID: <47E43F21.3000109@emulex.com>
References: <20080318133228.61EE225918@pentland.suse.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62990 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763702AbYCUXFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2008 19:05:14 -0400
In-Reply-To: <20080318133228.61EE225918@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

ACK.

-- james s

Hannes Reinecke wrote:
> lpfc and qla2xxx overwrite the standard 'state' attribute with
> custom callbacks. So rename the custom attributes to 'link_state'
> and retain the original meaning of the 'state' attribute.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c   |   10 +++++-----
>  drivers/scsi/qla2xxx/qla_attr.c |    8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
