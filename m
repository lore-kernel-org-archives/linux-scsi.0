From: "Grant Grundler" <grundler@google.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 28 Mar 2008 17:49:07 -0700
Message-ID: <da824cf30803281749l614c3592t89cce073c9b043c8@mail.gmail.com>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	 <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
	 <1206743181.3662.55.camel@localhost.localdomain>
	 <20080328224335.1f14cf6a@core>
	 <1206748313.3662.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:22953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYC2AtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2008 20:49:12 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id m2T0n8Bp020441
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 17:49:08 -0700
Received: from rv-out-0910.google.com (rvfc24.prod.google.com [10.140.180.24])
	by zps77.corp.google.com with ESMTP id m2T0n8dk003751
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 17:49:08 -0700
Received: by rv-out-0910.google.com with SMTP id c24so252891rvf.15
        for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 17:49:07 -0700 (PDT)
In-Reply-To: <1206748313.3662.66.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, Mar 28, 2008 at 4:51 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
...
>  So basically, most of the cpu_to_le32 in this driver look wrong.  If I
>  can fix it (or persuade someone else to fix it) can anyone test it on a
>  BE platform?

But the code I submitted the patch is also broken for LE platforms.
(As you pointed out earlier and was my original incentive for
submitting the patch).

If most of the usage is wrong anyway, perhaps it's better to
not pretend the driver can work on a BE platform and just rip
all the cpu_to_le32() usage out...including the one I submitted
the patch for. Either way, that change should go in. Right?

hth,
grant
