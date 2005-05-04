From: kylin <fierykylin@gmail.com>
Subject: Re: PCI express equipment
Date: Thu, 5 May 2005 00:28:17 +0800
Message-ID: <87ab37ab05050409283d26dcab@mail.gmail.com>
References: <87ab37ab05050404516a2bcc40@mail.gmail.com>
	 <20050504121420.GH19678@parcelfarce.linux.theplanet.co.uk>
Reply-To: kylin <fierykylin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.206]:64313 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261913AbVEDQ2S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2005 12:28:18 -0400
Received: by zproxy.gmail.com with SMTP id 18so360364nzp
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2005 09:28:18 -0700 (PDT)
In-Reply-To: <20050504121420.GH19678@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On 5/4/05, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, May 04, 2005 at 07:51:12PM +0800, kylin wrote:
> > On one hand ,hardwarely,as it is always said, PCIE provides the
> > superexcellent performance
> >
> > comparing with the PCI and PCI -X
> > On the other ,softwarely,in most the application scenarios i have met
> > , the PCIE equipment will
> >
> > have to use the pci-compatible driver first in linux.
> > because the Configuration head is pci compatible in the first 256 byte ,
> > it is allowed and really works.
> > i know if we use the conventional Device Driver for pcie equipment,
> > the advanced option such as MSI ,Flow Control ,TC ,VC and hotplug are
> 
> rubbish.  MSI and Hotplug are independent of PCI Express and are used
> by conventional PCI drivers today.  Flow control, TC and VC are all part
> of the same thing.
sorry for my innocence,but all i want to say here is if the unMSI and
unHotplug device driver would influence the normal speed in ONE 
common  scenarios
> > unavailable, i also know
> >
> > that the speed is mainly the problem of Bandwidth and Clocking. Still
> > i know that the Trafic
> >
> > control mechanism is good for the arbitration and thus improve the
> > performance just like the
> >
> > TCP protocol ways.
> 
> Um, no, not really.  There's very little hardware support for VC/TC at the
> moment, so having software support for it isn't a priority. 
yeah ,even the bios will rarely support this

> In addition,
> it really depends how deep your PCI bus hierarchy is whether VC/TC will
> have any effect on performance at all.
have you seen the E7520 chipset ,sir? 
> Why is this question on linux-scsi anyway?
because myu SCSI interface is connecting to the pcie bus:),love it and
love the dog :)

-- 
we who r about to die,salute u!
