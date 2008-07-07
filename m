From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] sym53c8xx: Fix bogus sym_que_entry re-implementation of container_of
Date: Mon, 7 Jul 2008 08:02:06 -0700
Message-ID: <da824cf30807070802g48fc84b1la2ad982a6c0d1acd@mail.gmail.com>
References: <20080707005030.503A3DDE08@ozlabs.org>
	 <da824cf30807062335q5057a816wf4071bbec3052093@mail.gmail.com>
	 <1215413017.8970.101.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:19091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYGGPCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 11:02:17 -0400
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id m67F27dK013404
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2008 16:02:08 +0100
Received: from wf-out-1314.google.com (wfg23.prod.google.com [10.142.7.23])
	by zps78.corp.google.com with ESMTP id m67F266m019983
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2008 08:02:06 -0700
Received: by wf-out-1314.google.com with SMTP id 23so2432574wfg.25
        for <linux-scsi@vger.kernel.org>; Mon, 07 Jul 2008 08:02:06 -0700 (PDT)
In-Reply-To: <1215413017.8970.101.camel@pasglop>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Matthew Wilcox <matthew@wil.cx>

On Sun, Jul 6, 2008 at 11:43 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sun, 2008-07-06 at 23:35 -0700, Grant Grundler wrote:
...
>> There are 11 uses of sym_que_entry() macro. Is that too many to
>> completely remove it's use?
>> (question for willy to decide I guess).
>
> Willy wants to completely remove the queue management. While that might
> be the right thing to do, I'd like the small fixup to go in to at least
> remove the warnings in the meantime.

ok - I didn't know the long term plan. That seems reasonable to me.

BTW, I realized this morning sym_que_entry() should really be an
inline function and drop the "struct sym_ccb" argument.

thanks,
grant
