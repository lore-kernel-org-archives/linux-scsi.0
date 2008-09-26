From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
Date: Fri, 26 Sep 2008 09:11:51 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F280E8@HQ-EXCH-5.corp.brocade.com>
References: <200809260106.m8Q160kj028501@swe37.brocade.com> <20080926025514.GD9480@kroah.com> <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com> <1222408937.3265.17.camel@localhost.localdomain> <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com> <48DCC284.3040408@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:50087 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbYIZQLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 12:11:54 -0400
Content-class: urn:content-classes:message
In-Reply-To: <48DCC284.3040408@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

Thanks James. I guess I need to follow up all the updates on this front,
and will change our management tools accordingly.

Jing

-----Original Message-----
From: James Smart [mailto:James.Smart@Emulex.Com] 
Sent: Friday, September 26, 2008 4:08 AM
To: Jing Huang
Cc: James Bottomley; Greg KH; linux-kernel@vger.kernel.org;
linux-scsi@vger.kernel.org; Ramkumar Vadivelu; Srikanth Rayas (CW);
Vinodh Ravindran
Subject: Re: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission
(2ndtry)

We are finally finishing up CT/ELS passthru in the FC transport; SCSI 
passthru exists, but via the scsi_generic driver (so it's not part of 
the transport or LLDD); and async event notification is already present 
in the fc transport.

-- james s

Jing Huang wrote:
> Hi James,
> 
> It is encouraging to know that we can discuss and add new feature into
> existing fc transport. I guess this is opensource all about. I didn't
> have linux opensource experience before, so I was not quite sure how
> easy to request new features in fc transport such as mechanism to
create
> multiple subdirectories for different level of statistics info in
> addition to the snia fc statitistics we already have, and other
features
> such as CT/SCSI passthru and asynchronous event notification etc.
> 
> Thanks
> 
> Jing
