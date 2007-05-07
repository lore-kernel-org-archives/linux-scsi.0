From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: [PATCH] zfcp: Stop system after memory corruption
Date: Tue, 8 May 2007 01:56:07 +1000
Message-ID: <646765f40705070856y28d958f8xe2e286ab347d63a5@mail.gmail.com>
References: <200705071635.04585.swen.schillig@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:57522 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934400AbXEGP4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 11:56:10 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1634834wra
        for <linux-scsi@vger.kernel.org>; Mon, 07 May 2007 08:56:09 -0700 (PDT)
In-Reply-To: <200705071635.04585.swen.schillig@freenet.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen.schillig@freenet.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On 5/8/07, Swen Schillig <swen.schillig@freenet.de> wrote:
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
[snip]
> -                               ZFCP_LOG_NORMAL("bug: unexpected inbound "
> -                                               "packet on adapter %s "
> -                                               "(reqid=0x%lx, "
> -                                               "first_element=%d, "
> -                                               "elements_processed=%d)\n",
> -                                               zfcp_get_busid_by_adapter(adapter),
> -                                               (unsigned long) buffere->addr,
> -                                               first_element,
> -                                               elements_processed);
> -                               ZFCP_LOG_NORMAL("hex dump of inbound buffer "
> -                                               "at address %p "
> -                                               "(buffer_index=%d, "
> -                                               "buffere_index=%d)\n", buffer,
> -                                               buffer_index, buffere_index);
> -                               ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
> -                                             (char *) buffer, SBAL_SIZE);

As a minor quibble, may I suggest that these lines belong just above
the panic introduced above? I assume that they'd be useful for
debugging should this situation occur.

If I'm completely mis-understanding the situation, please disregard this email.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com

(please note that I'm only subscribed to linux-scsi if replying)
