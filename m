From: Hadmut Danisch <hadmut@danisch.de>
Subject: Re: aic79xx and RAID ?
Date: Thu, 1 Dec 2005 11:48:05 +0100
Message-ID: <20051201104805.GA3893@danisch.de>
References: <20051201102039.GA23336@danisch.de> <1133433450.2853.25.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sklave3.rackland.de ([213.133.101.23]:52178 "EHLO
	sklave3.rackland.de") by vger.kernel.org with ESMTP
	id S1750754AbVLAKsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 05:48:10 -0500
Content-Disposition: inline
In-Reply-To: <1133433450.2853.25.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hi,

thanks for the fast reply. :-)


On Thu, Dec 01, 2005 at 11:37:30AM +0100, Arjan van de Ven wrote:
>
> ah one of the software raid controllers
> 
..
> this is in principle the right thing for this kind of software raid.
> the dmraid tool is there to support this type of software raid (bios
> supported raid) but I don't think it supports adaptec raid yet...



A software raid controller?  Never heard of such a beast before. 


I always thought that there are exactly two ways to do raid, 
one way is to have it all hidden in the controller, which makes the
RAID mirror appear as just a single disk to the kernel, 
and the other way is to use the kernel software raid (configured with
mdadm). 

I've never heard of a software raid controller, where the kernel must
do the work itself. After all, what's the controller's job and
why is it called a RAID controller then? 


But I guess we have to use software (i.e. kernel driven, mdadm) raid
then?


regards
Hadmut




