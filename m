From: Jes Sorensen <jes@sgi.com>
Subject: Re: [PATCH] qla1280: use request_firmware
Date: Mon, 14 Jul 2008 16:03:31 +0200
Message-ID: <487B5CB3.60207@sgi.com>
References: <1215770284.2733.10.camel@jaswinder.satnam>	 <487B1C73.5000202@sgi.com> <1216039088.10198.8.camel@jaswinder.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:39043 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753664AbYGNODg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 10:03:36 -0400
In-Reply-To: <1216039088.10198.8.camel@jaswinder.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, kernel-janitors <kernel-janitors@vger.kernel.org>, kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org, hch@infradead.org

Jaswinder Singh wrote:
> We have not changed the data.
> We are passing risc_code01 data by using request_firmware when required.
> 
> If you found some problem in the code, Please let me know.

My issue was not about changing the format of the data, but about it
being forced into userland, ie. requiring an initrd. After speaking to
Woodhouse over irc, I have learned that with the new firmware
infrastructure this is optional and one can still link the firmware into
the kernel.

Given that the previous firmware moving patches have always been about
getting firmware out of the kernel due to certain distro's being silly
about it, this wasn't actually obvious. If your patch description had
been a little more detailed and explained that it didn't require
firmware to go into userland it would have been easier for someone who
hasn't been following the previous thread on the subject.

So, I don't have any objections to this patch as long as the new
firmware interface continues to allow me to link this into the kernel.

Regards,
Jes

