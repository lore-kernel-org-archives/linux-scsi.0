From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [PATCH][RELEASE] megaraid 2.10.2 Driver
Date: Tue, 23 Mar 2004 11:00:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230C77D@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2439 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262623AbUCWQB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 11:01:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <willy@debian.org>, Christoph Hellwig <hch@infradead.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Jeff Garzik' <jgarzik@pobox.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'marcelo@cyclades.com.br'" <marcelo@cyclades.com.br>, "'marcelo.tosatti@cyclades.com'" <marcelo.tosatti@cyclades.com>

>> > I don't think you understand how CONFIG_COMPAT works.  
>x86-64 defines it
>> > when it wants it:
>> 
>> But not in 2.4, and this is a 2.4-only patch..
>
>It is?  I didn't see that mentioned anywhere.

My fault. I will be more thorough from now on. Thanks for pointing that out.

>
>Anyway, it's wrong to define LSI_CONFIG_COMPAT based solely on 
>__x86_64__.
>You'd also need to check IA32_EMULATION.  Really, it would be simpler
>to add CONFIG_COMPAT to 2.4.
>

Most of the objections centered around CONFIG_COMPAT issue. If we have 
to support 32-bit applications on lk 2.4, what is the right way to do it?
Any
helpful suggestions are appreciated.

>So you can only copy to the bottom 4GB of user address space? That
>seems like a recipe for disaster. Particularly on ia64.

This interface is only for 32-bit applications. If and when we have 64-bit
apps,
they use a different (new) interface.

>and everything will be fine. Please don't introduce this stupid
>unnecessary LSI_CONFIG_COMPAT. That just makes people say "what the
>**** are they doing?".

May I also respectfully suggest that you don't use any F* or similar words
in
your mails, for the sole reason that our corporate server filters those
mails out.
We had to infer from Christoph's mail that you had responded earlier. We
don't
want to miss your valuable feedback.

Thank you,
Sreenivas
