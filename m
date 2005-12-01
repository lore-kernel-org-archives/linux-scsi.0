From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: aic79xx and RAID ?
Date: Thu, 01 Dec 2005 11:53:10 +0100
Message-ID: <1133434390.2853.30.camel@laptopd505.fenrus.org>
References: <20051201102039.GA23336@danisch.de>
	 <1133433450.2853.25.camel@laptopd505.fenrus.org>
	 <20051201104805.GA3893@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58015 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932143AbVLAKxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 05:53:12 -0500
In-Reply-To: <20051201104805.GA3893@danisch.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hadmut Danisch <hadmut@danisch.de>
Cc: linux-scsi@vger.kernel.org


> ..
> > this is in principle the right thing for this kind of software raid.
> > the dmraid tool is there to support this type of software raid (bios
> > supported raid) but I don't think it supports adaptec raid yet...
> 
> 
> 
> A software raid controller?  Never heard of such a beast before. 

it's software raid but with support from the cards bios so that you can
boot from it.


> I always thought that there are exactly two ways to do raid, 
> one way is to have it all hidden in the controller, which makes the
> RAID mirror appear as just a single disk to the kernel, 
> and the other way is to use the kernel software raid 

this is basically a correct understanding, and your card is of the
second type.

> (configured with
> mdadm). 

there are multiple classes of software raid now; some are driven by
device mapper.


> I've never heard of a software raid controller, where the kernel must
> do the work itself. After all, what's the controller's job and
> why is it called a RAID controller then? 

marketing speak... the kernel does all the work. just they sell you a
driver for windows that hides this, as well as a bios rom that allows
you to boot from it.... but other than that it's just software raid.


> But I guess we have to use software (i.e. kernel driven, mdadm) raid
> then?
> 

as I said, dmraid (using device mapper) is designed for this type of
software raid...


