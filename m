From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] sg: limit maximum cdb size to 252 bytes
Date: Thu, 26 Jun 2014 10:57:14 -0400
Message-ID: <1403794634.6423.283.camel@localhost.localdomain>
References: <53AB0166.8060905@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791AbaFZO5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 10:57:22 -0400
In-Reply-To: <53AB0166.8060905@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Boaz Harrosh <bharrosh@panasas.com>

On Wed, 2014-06-25 at 13:05 -0400, Douglas Gilbert wrote:
> Boaz Harrosh commented on the "[PATCH v5] sg: relax 16
> byte cdb restriction" thread that SCSI variable length
> commands (which are all SCSI commands greater than 16
> bytes long) must themselves be a multiple of 4 bytes
> long.
> 
> ChangeLog
>    - limit the maximum cdb size permitted by the sg
>      v3 interface to 252 bytes. Commands that large
>      are called "variable length" and their length
>      needs to be a multiple of 4.
> 
> Original patch:
>    Reviewed-by: Boaz Harrosh <boaz@electrozaur.com>
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> 

Sure.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


