From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: FW: [PATCH] 2.4.25-pre4 SCSI fusion driver
Date: Thu, 22 Jan 2004 10:50:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703A7603B@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:24033 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264502AbUAVPvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 10:51:11 -0500
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, "Stephens, Larry" <larry.stephens@lsil.com>
Cc: "Gibbons, Terry" <Terry.Gibbons@lsil.com>, "'xose@wanadoo.es'" <xose@wanadoo.es>, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>

On Thursday, January 22, 2004 5:55 AM, Marcelo Tosatti wrote:
> The thing is 2.4 does not define CONFIG_COMPAT. Who defines it? SPARC
> users have to do it manually now?

I was involved with the CONFIG_COMPAT fix's. They were for
I customer having a 32bit application running on x86_64.  The
mpt driver isn't enabling the CONFIG_COMPAT define.  I tested
this change on SuSE Sles and Redhats Rhes enterprise editions using their
respective lastest service packs and updates, and it seemed to get enabled.
Maybe this occured in the x86_64 branch?
  
> 
> Other than this this looks fine. What tests have been to this
> modifications?
> 

This 2.05.11 driver spent the month of November in 
the LSI Loigic qualification test labs. We have since 
provided driver update RPMs to customers, and its
currently in use in the field.

Eric



