From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: [PATCH] zfcp: Stop system after memory corruption
Date: Tue, 8 May 2007 23:24:01 +1000
Message-ID: <646765f40705080624s1c0ac0ddt15d3c4ac5b3246b4@mail.gmail.com>
References: <200705071635.04585.swen.schillig@freenet.de>
	 <646765f40705070856y28d958f8xe2e286ab347d63a5@mail.gmail.com>
	 <20070508125824.GA14085@schmichrtp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:59082 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566AbXEHNYC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 09:24:02 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1962927wra
        for <linux-scsi@vger.kernel.org>; Tue, 08 May 2007 06:24:02 -0700 (PDT)
In-Reply-To: <20070508125824.GA14085@schmichrtp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Swen Schillig <swen.schillig@freenet.de>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On 5/8/07, Christof Schmitt <christof.schmitt@de.ibm.com> wrote:
> On Tue, May 08, 2007 at 01:56:07AM +1000, Julian Calaby wrote:
> > >From: Christof Schmitt <christof.schmitt@de.ibm.com>
> > [snip]
> > >-                               ZFCP_LOG_NORMAL("bug: unexpected inbound "
> > >-                                               "packet on adapter %s "
> > >-                                               "(reqid=0x%lx, "
> > >-                                               "first_element=%d, "
> > >-                                               "elements_processed=%d)\n",
> [...]
> > As a minor quibble, may I suggest that these lines belong just above
> > the panic introduced above? I assume that they'd be useful for
> > debugging should this situation occur.
>
> If this problem occurs, the administrator of the Linux system will be
> advised to dump the Linux system and to also capture the logs from the
> FCP adapter. The memory dump already contains the information about the
> unexpected packet and also information about the last requests
> sent to the FCP adapter. So, the messages do not provide additional
> debug data, and i removed them to simplify the code.

Ah!

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
