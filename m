From: "Nikhil Dharashivkar" <dharashivkar.nikhil@spsoftindia.com>
Subject: Re: scsi Target card and scsi Initiator card
Date: Mon, 11 Oct 2004 11:07:45 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <01c601c4af54$7054dd20$1610a8c0@spsoft.com>
References: <017e01c4ab91$510a3e90$1610a8c0@spsoft.com> <4163DDC6.3030102@vlnb.net> <017901c4ac30$cde21510$1610a8c0@spsoft.com> <4164F258.9090508@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 134-215-187-203.cable-client.iqara.net ([203.187.215.134]:20626
	"EHLO mailserver.spsoftindia.com") by vger.kernel.org with ESMTP
	id S268698AbUJKFkb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 01:40:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org

Hi ....
     I have gone thr' documents that discribe Target Emulator or that type
of software layer.
     I have LSI22320-R with LSI1030 and LSI1030T (Two Cards). I also have
driver Tekram (Initiator Card).
   Now I joind Tekram and LSI card with external scsi cable. Connection was
done and disk also exposed from LSI Card to Tekram.
Basically LSI card that i have contains Inititator/Target mode firmware.
    So What i want to do , to make LSI card to run in only Target Mode. For
that , Can i write a kernel module that can read incomming scsi
commands from any initiator card (here Tekram) to the LSI card. and that
module will invoke the firware on the LSI card intead directly by commnads ?
What i think here that i have to do low level i..e card level programming to
get these scsi commands , is it possible / feasible ?


Regrads,
Nikhil.

----- Original Message -----
From: "Vladislav Bolkhovitin" <vst@vlnb.net>
To: "Nikhil Dharashivkar" <dharashivkar.nikhil@spsoftindia.com>
Cc: <linux-scsi@vger.kernel.org>
Sent: Thursday, October 07, 2004 1:08 PM
Subject: Re: scsi Target card and scsi Initiator card


> Nikhil Dharashivkar wrote:
> > Hi,
> >      Actually our setup of hardware is : There is one board . On that we
> > have one target mode card (LSI) and more than one initiator cards.
> >        First thing I have to do is I should able to export all LUNS or
> > target devices connected to initiator card through this target mode
card.
> >       For that how should i think to develop software layer . Is there
> > already implemeted code ?
>
> Take a look on SCSI target mid-level (SCST) on
> http://scst.sourceforge.net. You just need to develop small target
> add-on to the LSI's initiator driver as it was done for Qlogic cards.
>
> Vlad
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

