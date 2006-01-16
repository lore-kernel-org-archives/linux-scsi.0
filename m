From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] aic79xx: Update to adaptec version 2.0.15
Date: Mon, 16 Jan 2006 12:06:20 +0000
Message-ID: <20060116120620.GC12554@infradead.org>
References: <43CB6FAF.5080000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28644 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750726AbWAPMGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 07:06:22 -0500
Content-Disposition: inline
In-Reply-To: <43CB6FAF.5080000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>  aicdb.h:
> -	@if [ -e "/usr/include/db4/db_185.h" ]; then		\
> -		echo "#include <db4/db_185.h>" > aicdb.h;	\
> -	 elif [ -e "/usr/include/db3/db_185.h" ]; then		\
> +	@if [ -e "/usr/include/db3/db_185.h" ]; then		\
>  		echo "#include <db3/db_185.h>" > aicdb.h;	\
>  	 elif [ -e "/usr/include/db2/db_185.h" ]; then		\
>  		echo "#include <db2/db_185.h>" > aicdb.h;	\
> -	 elif [ -e "/usr/include/db1/db_185.h" ]; then		\
> -		echo "#include <db1/db_185.h>" > aicdb.h;	\
>  	 elif [ -e "/usr/include/db/db_185.h" ]; then		\
>  		echo "#include <db/db_185.h>" > aicdb.h;	\
>  	 elif [ -e "/usr/include/db_185.h" ]; then		\

this backs out fixes for people with various db versions.

