From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/24] advansys: Make advansys_board_found a little more
 readable
Date: Fri, 27 Jul 2007 10:04:51 -0400
Message-ID: <46A9FB83.4010901@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <1185543753768-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57972 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbXG0OEy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:04:54 -0400
In-Reply-To: <1185543753768-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> +	goto exit;
> +
> + kmalloc_failed:
> +	ASC_PRINT1("advansys_wide_init_chip: board %d error: kmalloc() "
> +		   "failed\n", boardp->id);
> +	err_code = ADV_ERROR;
> + exit:
> +	return err_code;
> +}


Regardless of the original code, it is quite irregular to force the 
caller to clean up after advansys_wide_init_chip() kmalloc failure.  I 
could understand it, perhaps, if err_free_wide_mem label was used more 
than once, but it's not.

	Jeff


