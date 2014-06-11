From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v5] sg: relax 16 byte cdb restriction
Date: Wed, 11 Jun 2014 16:37:54 -0500
Message-ID: <5398CC32.9070201@cs.wisc.edu>
References: <538E035A.10703@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39854 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaFKViF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 17:38:05 -0400
In-Reply-To: <538E035A.10703@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christian Franke <Christian.Franke@t-online.de>, James Bottomley <james.bottomley@hansenpartnership.com>

On 06/03/2014 12:18 PM, Douglas Gilbert wrote:
> v4 of this patch was sent 20131201.
> 
> ChangeLog:
>         - remove the 16 byte CDB (SCSI command) length limit
>           from the sg driver by handling longer CDBs the same
>           way as the bsg driver. Remove comment from sg.h
>           public interface about the cmd_len field being
>           limited to 16 bytes.
>         - remove some dead code caused by this change
>         - cleanup comment block at the top of sg.h, fix urls
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
