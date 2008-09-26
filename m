From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
Date: Fri, 26 Sep 2008 07:07:48 -0400
Message-ID: <48DCC284.3040408@emulex.com>
References: <200809260106.m8Q160kj028501@swe37.brocade.com> <20080926025514.GD9480@kroah.com> <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com> <1222408937.3265.17.camel@localhost.localdomain> <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54773 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYIZLIT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 07:08:19 -0400
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

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
> easy to request new features in fc transport such as mechanism to create
> multiple subdirectories for different level of statistics info in
> addition to the snia fc statitistics we already have, and other features
> such as CT/SCSI passthru and asynchronous event notification etc.
> 
> Thanks
> 
> Jing
