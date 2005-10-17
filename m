From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Mon, 17 Oct 2005 20:55:11 +1000
Message-ID: <4353830F.3010104@torque.net>
References: <20051015013824.GA25248@linux-mips.org> <1129544373.2907.18.camel@laptopd505.fenrus.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:15828 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932255AbVJQKy1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:54:27 -0400
In-Reply-To: <1129544373.2907.18.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 2005-10-15 at 02:38 +0100, Ralf Baechle wrote:
> 
>>FYI and reviewing pleassure.
>>
>>Author: Thiemo Seufer <ths@networkno.de>
>>Date:   Tue Apr 12 14:00:38 2005 +0000
>>
>>Enable proc support, minor code cleanup.
> 
> 
> isn't this the wrong way around; eg afaik we're deprecating proc support
> from LLDD's...

No more ioctls for LLDDs, no more procfs, just a sysfs
straight jacket; until sysfs goes the way of devfs ...

A subversive thought: a SAS LLDD supporting a SMP target
(as well as the standard SSP,SMP and STP initiators).
Then, via vendor specific SMP functions, control apps
can access the HBA to do things that linux disallows
or makes difficult :-)
[May not work unless HBAs have the equivalent of
the network "lo" interface.]

Doug Gilbert
