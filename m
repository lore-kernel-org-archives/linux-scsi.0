From: "Grant Grundler" <grundler@google.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Mon, 31 Mar 2008 09:23:31 -0700
Message-ID: <da824cf30803310923i4a747cfbk185792afbc3b27e@mail.gmail.com>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	 <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
	 <1206743181.3662.55.camel@localhost.localdomain>
	 <20080328224335.1f14cf6a@core>
	 <1206748313.3662.66.camel@localhost.localdomain>
	 <da824cf30803281749l614c3592t89cce073c9b043c8@mail.gmail.com>
	 <1206760156.3662.79.camel@localhost.localdomain>
	 <da824cf30803302150m8157e8aob5914f8efef58ed9@mail.gmail.com>
	 <1206975406.3192.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:9641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYCaQXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 12:23:55 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id m2VGNk8n024857
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 17:23:47 +0100
Received: from wf-out-1314.google.com (wff29.prod.google.com [10.142.6.29])
	by zps36.corp.google.com with ESMTP id m2VGN2Fr004435
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 09:23:36 -0700
Received: by wf-out-1314.google.com with SMTP id 29so2562490wff.16
        for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 09:23:31 -0700 (PDT)
In-Reply-To: <1206975406.3192.16.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Mar 31, 2008 at 7:56 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
...
>  > After looking at the code for a bit, I think I would prefer to disable
>  > the driver entirely for BE platforms since it's pretty clear it could
>  > never work correctly. I'm not willing to own it for BE platforms.
>
>  Unfortunately, there's no way to do that which won't have the random
>  configuration people after you with a big stick ... we don't have a
>  config option for BE, only a runtime option ... make the compile break
>  and they'll find it and bug report it.
>
>  Don't worry, I won't make you own the BE part of this.  A reasonable fix
>  that looks like it has a chance of working will be fine.

Ok - I'll cook up a new patch that fixes the additional issues
in the next day or two. This means senselen will remain u8 and
only the sg list handling will use cpu_to_le32.

thanks,
grant
