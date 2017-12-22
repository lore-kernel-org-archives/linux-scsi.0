From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: remove extra white space at the end of the line
Date: Fri, 22 Dec 2017 08:03:18 +0100
Message-ID: <20171222070318.p4bor426wcc7kxwm@linux-x5ow.site>
References: <20171221024049.36509-1-yanaijie@huawei.com>
 <1513872544.2931.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751104AbdLVHDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Dec 2017 02:03:21 -0500
Content-Disposition: inline
In-Reply-To: <1513872544.2931.13.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>

On Thu, Dec 21, 2017 at 04:09:07PM +0000, Bart Van Assche wrote:
> On Thu, 2017-12-21 at 10:40 +0800, Jason Yan wrote:
> > My editor always try to remove the extra white space at the end of the
> > line when I make some changes. I'm tired of adjusting them manually.
> > Can we remove them in mainline?
> 
> Hello Jason,
> 
> I think this means that your editor has been misconfigured. Any kernel code
> changes should be the result of a deliberate action by a human. Configuring an
> editor to apply any changes automatically to existing code is wrong.
> 
> There are several reasons why most kernel maintainers ignore patches like this
> one silently:
> * Whitespace changes make it harder than necessary to backport patches to
>   distro kernels. Before a patch that came later than the whitespace changes
>   can be backported, the whitespace change has to be backported. Additionally,
>   if a whitespace change touches many source files, the order in which to
>   backport patches becomes really important.

Honestly this is not so much of a problem, you either take the
whitespace patch once or work around it.

All in all I'm so much in favour of this cleanup patch (and even would
apprechiate more of these, especailly getting rid of all those
camelCase foo we have in the scsi hba drivers).

Let's see how Martin and James deceide about it.

Byte,
      Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
