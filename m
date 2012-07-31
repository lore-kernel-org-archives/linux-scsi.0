From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Tue, 31 Jul 2012 12:57:13 -0500
Message-ID: <CALAi6FdqR8Ljc75J76wu-SEwcSB1Zaz-eybq=DGdGkpxpNy90Q@mail.gmail.com>
References: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
	<1343611946.21647.23.camel@pasglop>
	<20120730190606.GD3155@aepfle.de>
	<1343704122.8227.3.camel@pasglop>
	<501805C3.7030504@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46139 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2GaR5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2012 13:57:14 -0400
Received: by yenl2 with SMTP id l2so6354152yen.19
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2012 10:57:14 -0700 (PDT)
In-Reply-To: <501805C3.7030504@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Olaf Hering <olaf@aepfle.de>, Brian J King <bjking1@us.ibm.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linuxppc-dev@ozlabs.org, Robert C Jennings <rcjenn@us.ibm.com>

On Tue, Jul 31, 2012 at 11:20 AM, Brian King <brking@linux.vnet.ibm.com> wrote:
>
> On 07/30/2012 10:08 PM, Benjamin Herrenschmidt wrote:
> > On Mon, 2012-07-30 at 21:06 +0200, Olaf Hering wrote:
> >>> So while this would work, I do wonder however whether we could
> >> instead
> >>> fix it by simplifying the whole thing as follow since iSeries is now
> >>> gone and so we don't need split backends anymore:
> >>>
> >>> scsi/ibmvscsi: Remove backend abstraction
> >>
> >> I cant that these things myself anymore.
> >
> > Brian, can somebody from your side own these ?
>
> I talked to Rob and he will be picking this up. Rob - can you submit
> a patch to the maintainers file, adding yourself as the ibmvscsi
> maintainer?

I've submitted a patch for the MAINTAINERS file and I'll take a look at these
patches to verify them as well.  Thanks.

--Rob Jennings
