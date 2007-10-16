From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 2/7] git scsi misc include fix
Date: Tue, 16 Oct 2007 14:33:53 -0700
Message-ID: <20071016143353.9a9b6ea6.randy.dunlap@oracle.com>
References: <200710162128.l9GLSKUF018167@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:12946 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965782AbXJPVeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 17:34:12 -0400
In-Reply-To: <200710162128.l9GLSKUF018167@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, pj@sgi.com

On Tue, 16 Oct 2007 14:28:20 -0700 akpm@linux-foundation.org wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> The added line in scsi_eh.h:
> 	struct scatterlist sense_sgl;
> fails to compile, with the error:
> 	field 'sense_sgl' has incomplete type
> unless scatterlist.h happens to be included
> somehow already ... which it isn't always.
> 
> So include scatterlist.h in scsi_eh.h directly.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/scsi/scsi_eh.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN include/scsi/scsi_eh.h~git-scsi-misc-include-fix include/scsi/scsi_eh.h
> --- a/include/scsi/scsi_eh.h~git-scsi-misc-include-fix
> +++ a/include/scsi/scsi_eh.h
> @@ -4,6 +4,7 @@
>  #include <linux/scatterlist.h>
>  
>  #include <scsi/scsi_cmnd.h>
> +#include <linux/scatterlist.h>
>  struct scsi_device;
>  struct Scsi_Host;

It's 3 lines above the patch line....


---
~Randy
