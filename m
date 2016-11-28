From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 28 Nov 2016 11:30:05 +0100
Message-ID: <20161128103005.c6ttwqoeif6wi7ns@linux-x5ow.site>
References: <1479738275.19792.24.camel@localhost.localdomain>
 <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
 <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
 <1479932524.28416.43.camel@localhost.localdomain>
 <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
 <CAPrnrPBcvBcNaZ5asJquRSp4Ann3xHVGSRbwLkvPF+YKJ6OpCw@mail.gmail.com>
 <20161125115317.llxd2lslf7ovitxd@linux-x5ow.site>
 <CAPrnrPBsBPH2B48QYLPCsdpg0LT7iBxc2+g+_xHPcDOjRf7f5A@mail.gmail.com>
 <805036857.58360.1480085165589.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37619 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754607AbcK1KaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 05:30:12 -0500
Content-Disposition: inline
In-Reply-To: <805036857.58360.1480085165589.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Eyal Ben David <bdeyal@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Fri, Nov 25, 2016 at 09:46:05AM -0500, Laurence Oberman wrote:

[...]

> 
> Johannes, you are reproducing another race in your test I think.
> 

This might actually be true. Disclaimer I'm hauntiung that one for quite some
time and now have a reproducer for it not just a downstream bug report.

I was tracing it down to the exact opposite of this KASAN report [1] which came
in over the weekend, so I'll be looking into this one as well now.

[1] http://www.spinics.net/lists/linux-scsi/msg102232.html

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
