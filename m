From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 4929] problem with aic7xxx driver on 2.6.x
Date: Fri, 29 Jul 2005 15:13:46 -0500
Message-ID: <1122668026.5108.23.camel@mulgrave>
References: <200507291650.j6TGoKTR022665@fire-1.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:9674 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S262805AbVG2UNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 16:13:51 -0400
In-Reply-To: <200507291650.j6TGoKTR022665@fire-1.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@kernel-bugs.osdl.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> ------- Additional Comments From duda@matrix.odessa.ua  2005-07-29 09:50 -------
> >Could you please test 2.6.13-rc4 and
> >if that also fails, test 2.6.13-rc3-mm3?
> yes , I found that these problems persist with this patches.
> 
> 
> > I think as a work around, a simple
> > echo scsi add-single-device 2 0 1 1 > /proc/scsi/scsi
> > should bring the missing LUN back again
> 
> Certainly it works. 
> But it would be desirable to resolve the problem with incorrect scanning LUN at
> loading the driver. 
> 
> If you need additional information about driver loading process , please email
> me with any questions.

Well, it can simply be fixed by blacklisting this array for the REPORT
LUNS command.  However, it would be nice to know what the reason for the
problem is.  The array claims to support REPORT LUNS but then apparently
returns rubbish when the command is sent.  The only people who would
know definitively what's going on is the manufacturer, can someone get
hold of them and ask?

Thanks,

James
 

