From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [SCSI] scsi_dh_alua: Attach to UNAVAILABLE/OFFLINE AAS
 devices
Date: Tue, 26 Apr 2011 16:24:50 -0500
Message-ID: <4DB73822.1050204@cs.wisc.edu>
References: <201104261827.06024.marting@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57482 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab1DZVYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2011 17:24:48 -0400
In-Reply-To: <201104261827.06024.marting@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin George <marting@netapp.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On 04/26/2011 07:57 AM, Martin George wrote:
> The SCSI ALUA handler currently fails to attach to devices
> reporting an UNAVAILABLE/OFFLINE AAS. But given that an
> UNAVAILABLE/OFFLINE AAS can transition to other states
> like ACTIVE/OPTIMIZED, ACTIVE/NON-OPTIMIZED, etc. as per
> SPC4, this ALUA handler behavior should be rectified so
> as to attach to devices which also report an
> UNAVAILABLE/OFFLINE AAS.
>

This makes sense to me. It reports it supports alua, so it seems that we 
should attach.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
