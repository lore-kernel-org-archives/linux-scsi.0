From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 13:25:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5129@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54157 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264852AbUFARZP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 13:25:15 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: linux-scsi@vger.kernel.org

PROC_SEXIUM was reserved by our application software group when we added
PROC_PENTIUM. PROC_SEXIUM was simply a `followon' processor of a
different feather. The dptsig.h file actually is shared with (many)
other sources, so it carries an impact.

Branching this file, notwithstanding ... sooo ... if it is to change,
maybe it should be set to PROC_EM64T ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Andi Kleen [mailto:ak@muc.de] 
Sent: Tuesday, June 01, 2004 1:09 PM
To: Salyzyn, Mark
Cc: linux-scsi@vger.kernel.org
Subject: Re: 2.6.6 + Adaptec I2O

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> writes:

> +	- Added __x86_64__ ifdef for signature, reporting PROC_SEXIUM
for
> +	  processor type.

PROC_QUINDECIUM would be more appropiate (both Nocona and Opteron use
x86 
model 15) 

-Andi

