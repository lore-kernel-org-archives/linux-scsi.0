From: Tim Cullen <timcullen2001@yahoo.com>
Subject: Re: scsi layer differences between 2.4 and 2.6
Date: Sun, 4 Jun 2006 10:31:32 -0700 (PDT)
Message-ID: <20060604173132.30735.qmail@web30312.mail.mud.yahoo.com>
References: <1149293976.3109.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30312.mail.mud.yahoo.com ([68.142.201.230]:29322 "HELO
	web30312.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750795AbWFDRbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jun 2006 13:31:33 -0400
In-Reply-To: <1149293976.3109.2.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

What is happening is that read and write performance
are lower on a 2.6 (SLES9 SP2) based kernel than on a
2.4 based kernel.

The test hardware is a Cray XT3 connected to a DDN
S2A8500 RAID array. The test is sequential reads and
writes from programs like sgp_dd and ior.

To be more specific, 2.4 peforms much better with IO
transfer sizes of 64k than the 2.6 kernel does. And in
some cases performs better with 1MB transfer sizes.

tim

--- Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 2006-06-02 at 14:23 -0700, Tim Cullen wrote:
> > Several of our customers as well as those of our
> > partners have been inquiring about a performance
> > regression that looks like its being caused by the
> > scsi layer in the 2.6 kernel. Compared to the
> > performance that can been seen using the same
> hardware
> > with a 2.4 kernel.
> > 
> > Can somebody give me a summary of the changes that
> > were made to the scsi layer between 2.4 and 2.6?
> 
> "it got rewritten".
> 
> Can you provide more information on what is
> happening? Like which
> hardware, which drivers, what kind of workloads etc
> ?
> 
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
