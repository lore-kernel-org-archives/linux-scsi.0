From: "Nikhil Dharashivkar" <dharashivkar.nikhil@spsoftindia.com>
Subject: Re: scsi Target card and scsi Initiator card
Date: Thu, 7 Oct 2004 11:14:55 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <017901c4ac30$cde21510$1610a8c0@spsoft.com>
References: <017e01c4ab91$510a3e90$1610a8c0@spsoft.com> <4163DDC6.3030102@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 134-215-187-203.cable-client.iqara.net ([203.187.215.134]:28140
	"EHLO mailserver.spsoftindia.com") by vger.kernel.org with ESMTP
	id S269710AbUJGFrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 01:47:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>

Hi,
     Actually our setup of hardware is : There is one board . On that we
have one target mode card (LSI) and more than one initiator cards.
       First thing I have to do is I should able to export all LUNS or
target devices connected to initiator card through this target mode card.
      For that how should i think to develop software layer . Is there
already implemeted code ?


 ---- Original Message -----
From: "Vladislav Bolkhovitin" <vst@vlnb.net>
To: "Nikhil Dharashivkar" <dharashivkar.nikhil@spsoftindia.com>
Sent: Wednesday, October 06, 2004 5:27 PM
Subject: Re: scsi Target card and scsi Initiator card


> Nikhil,
>
> Everything is done according to appropriate SCSI standards, like Fibre
> Channel or iSCSI. Try to find their description, for example, on
> http://www.t10.org.
>
> Best regards,
> Vlad
>
> Nikhil Dharashivkar wrote:
> > hi all,
> >     I want to know how target card is exposed to the intiator.
> > How connectivity is done between both cards. How luns are exposed from
> > target mode card to initiator card.
> >  How communication is done when there is one target mode card and
multiple
> > initiator cards.
> >
> >
> > Thanks,
> >  Nikhil.
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >

