From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [RFC] [PATCH 0/7] requested for qla4xxx!!!
Date: Sat, 01 Jul 2006 23:27:56 +0400
Message-ID: <44A6CCBC.7000603@tls.msk.ru>
References: <20060629064812.GA7220@ranandlinuxbox.oc.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:17243 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S1750978AbWGAT2B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2006 15:28:01 -0400
In-Reply-To: <20060629064812.GA7220@ranandlinuxbox.oc.cox.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, open-iscsi <open-iscsi@googlegroups.com>

[Sorry for repost: was typo in linux-scsi@vger
 email, and open-iscsi@ didn't accept email
 either, as it says "i'm not subscribed" (which
 isn't _entirely_ true ;)]

Ravi Anand wrote:
> All,
> 
> Today in the following email thread , Mike Christie outlined the 
> modifications that has been done to qla4xx driver from the last submission: 
> 
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=115151443814051&w=2
[...]
> All the patches has been uploaded at the following URL:
>
> 	ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b6-k/
>
> Complete driver package and the diff from previous submission for review
> has also been uploaded at the above mentioned link.
[...]

Hi.

I'm not of much help in reviewing the code and/or making code
suggestions.  Instead, I'm trying to build the driver as we've
several new servers with ISP4010 adapters, which should work
somehow... ;)

Except of the obvious prob wrt ql4_netlink.h file which you
already fixed by subsequent patch.. well....

....Ok.  I'm new in this area (just joined open-iscsi list).
And my first question is: which [i]scsi implementation you
were used as a base for this driver?

I've tried against curren open-iscsi svn repo, against
scsi-misc kernel git tree, and against open-iscsi-1.0-485
tarball.  Whch all are mostly similar (in API anyway).
ql4 driver does not compile - even after "fixing" some
"missing" #includes (like iscsi_if.h defining most of
the ISCSI_* constants used in ql4_os.c), there are alot
of functions missing (iscsi_{add,remove,free}_session()
etc), undeclared structures used (*dscvr*) etc.

What was used as a base for the work?

And also -- how ql3 driver is related to this ql4 one?
Does it (ql4) require ql3 to be compiled/loaded as well?
(The question is because, as it seems, the card represents
as two PCI (sub)devices - one is ethernet controller and
another is "network controller", like this:

04:04.0 Ethernet controller: QLogic Corp. QLA3010 Network Adapter (rev 05)
04:04.1 Network controller: QLogic Corp. QLA4010 iSCSI TOE Adapter (rev 05)
)

Thanks.

/mjt
