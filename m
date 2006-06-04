From: Tim Cullen <timcullen2001@yahoo.com>
Subject: Re: scsi layer differences between 2.4 and 2.6
Date: Sun, 4 Jun 2006 11:56:31 -0700 (PDT)
Message-ID: <20060604185631.75203.qmail@web30307.mail.mud.yahoo.com>
References: <1149442944.3109.124.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30307.mail.mud.yahoo.com ([68.142.200.100]:45924 "HELO
	web30307.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750971AbWFDS4c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jun 2006 14:56:32 -0400
In-Reply-To: <1149442944.3109.124.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

Its a Qlogic ISP23xx. Sorry I can't provide more
details about the HBAs configuration. I don't
currently have access to the test machine.

tim

--- Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 2006-06-04 at 10:31 -0700, Tim Cullen wrote:
> > What is happening is that read and write
> performance
> > are lower on a 2.6 (SLES9 SP2) based kernel than
> on a
> > 2.4 based kernel.
> > 
> > The test hardware is a Cray XT3 connected to a DDN
> > S2A8500 RAID array. The test is sequential reads
> and
> > writes from programs like sgp_dd and ior.
> 
> what is the HBA in use? (eg which driver?)
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
