From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] scsi: Conditionally compile in constants.c
Date: Wed, 5 Nov 2014 23:19:43 -0800
Message-ID: <20141106071943.GE19721@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaKFHTp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:19:45 -0500
Content-Disposition: inline
In-Reply-To: <1415088409-46590-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

> +static inline const char *scsi_sense_key_string(unsigned char key)
> +{ return NULL; }
> +static inline const char *scsi_extd_sense_format(unsigned char asc,
> +					  unsigned char ascq,
> +					  const char **fmt)
> +{ *fmt = NULL; return NULL; }
> +static inline const char *scsi_mlreturn_string(int result)
> +{ return NULL; }
> +static inline const char *scsi_hostbyte_string(int result)
> +{ return NULL; }
> +static inline const char *scsi_driverbyte_string(int result)
> +{ return NULL; }

Please apply the normal code formatting rules to these.

Otherwise looks fine,,

Reviewed-by: Christoph Hellwig <hch@lst.de>
