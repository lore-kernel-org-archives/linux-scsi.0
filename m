From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PCI express equipment
Date: Wed, 4 May 2005 13:14:20 +0100
Message-ID: <20050504121420.GH19678@parcelfarce.linux.theplanet.co.uk>
References: <87ab37ab05050404516a2bcc40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42141 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261683AbVEDMNx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2005 08:13:53 -0400
Content-Disposition: inline
In-Reply-To: <87ab37ab05050404516a2bcc40@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kylin <fierykylin@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, May 04, 2005 at 07:51:12PM +0800, kylin wrote:
> On one hand ,hardwarely,as it is always said, PCIE provides the
> superexcellent performance
> 
> comparing with the PCI and PCI -X 
> On the other ,softwarely,in most the application scenarios i have met
> , the PCIE equipment will
> 
> have to use the pci-compatible driver first in linux.
> because the Configuration head is pci compatible in the first 256 byte ,
> it is allowed and really works. 
> i know if we use the conventional Device Driver for pcie equipment,
> the advanced option such as MSI ,Flow Control ,TC ,VC and hotplug are

rubbish.  MSI and Hotplug are independent of PCI Express and are used
by conventional PCI drivers today.  Flow control, TC and VC are all part
of the same thing.

> unavailable, i also know
> 
> that the speed is mainly the problem of Bandwidth and Clocking. Still
> i know that the Trafic
> 
> control mechanism is good for the arbitration and thus improve the
> performance just like the
> 
> TCP protocol ways.

Um, no, not really.  There's very little hardware support for VC/TC at the
moment, so having software support for it isn't a priority.  In addition,
it really depends how deep your PCI bus hierarchy is whether VC/TC will
have any effect on performance at all.

Why is this question on linux-scsi anyway?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
