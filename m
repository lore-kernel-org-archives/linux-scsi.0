From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 12:43:22 -0400
Message-ID: <430F46AA.2050305@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com> <430E1CB1.1050108@s5r6.in-berlin.de> <430E24AB.2060002@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48310 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965108AbVHZQna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 12:43:30 -0400
In-Reply-To: <430E24AB.2060002@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, jejb@steeleye.com

On 08/25/05 16:06, Jeff Garzik wrote:
> Stefan Richter wrote:
> 
>>Luben Tuikov wanted...
>>
>>
>>>to move _away_ from HCIL.  So that addressing of devices in SCSI Core
>>>is _completely_ independent of addressing at the protocol layer.
>>
>>
>>I second that.
> 
> 
> 
> A move away from forced HCIL addressing would be a good thing.
> 
> However, its impossible to completely move away from addressing, as 
> userspace and the SCSI core need ways to route CDBs to devices based on 
> address.

They can use _anyone_ label in the label list of the LU.

The label itself is opaque to SCSI Core.  It may mean something
to users, it may mean something to the protocol layer, but to
SCSI Core it is completely opaque, and SCSI Core should _not_
try to interpret it/them.

Anyone, at any layer can add a label: protocol, SCSI Core,
Command set drivers, block subssytem, FS.

In fact, there is a dire need for this from several
storage vendors who want customers to look at the face of
the storage box (physical world) and then look into the
OS/Linux and see/know the device (correspondence).

Doing the HCIL juggle is the _ugliest_ thing currently
amongst all OSes.  Sadly, it had to take 5 years...

	Luben
P.S. Everyone, please don't remove CC entries from the email header, else
they go into my linux-scsi folder instead of my Inbox and it is
hard to track threads I'm participating in. 
If you didn't add it, don't remove it. :-) Thanks!


