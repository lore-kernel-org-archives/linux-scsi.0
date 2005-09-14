From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RESEND][PATCH 2.6.14-rc1] scsi: sd, sr, st, and scsi_lib all
 fail to copy cmd_len to new cmd
Date: Wed, 14 Sep 2005 11:57:47 +0200
Message-ID: <4327F41B.6080008@gmail.com>
References: <CA45571DE57E1C45BF3552118BA92C9D69BDE9@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wscnet.wsc.cz ([212.80.64.118]:30599 "EHLO wscnet.wsc.cz")
	by vger.kernel.org with ESMTP id S965131AbVINJ6N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 05:58:13 -0400
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BDE9@WDSCEXBECL03.sc.wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Timothy Thelin napsal(a):

>Sorry it wrapped.  It's now an attachment.
>
>This fixes an issue in scsi command initialization from a request
>where sd, sr, st, and scsi_lib all fail to copy the request's
>cmd_len to the scsi command's cmd_len field.
>
>Signed-off-by: Timothy Thelin <timothy.thelin@wdc.com>
>  
>
Mime is hell, include patch in e-mail's body, please.

thanks,

-- 
Jiri Slaby         www.fi.muni.cz/~xslaby
~\-/~      jirislaby@gmail.com      ~\-/~
241B347EC88228DE51EE A49C4A73A25004CB2A10

