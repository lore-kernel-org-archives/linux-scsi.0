From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: AIC7902 lockups
Date: Wed, 13 Aug 2003 12:37:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3244592704.1060799839@aslan.btc.adaptec.com>
References: <20030811143610.A19365@laokoon.bug.net> <2429712704.1060622870@aslan.btc.adaptec.com> <20030811204139.A26663@laokoon.bug.net>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:26325 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S275324AbTHMSfk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 14:35:40 -0400
In-Reply-To: <20030811204139.A26663@laokoon.bug.net>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>, linux-scsi@vger.kernel.org

>> The messages are not complete... the top is clipped.  Were you
>> using a serial console to capture this log?
> No, i did a "dmesg > file", but it seems the buffer is full after
> booting so the first parts are lost. I've put syslog files on the web:

...

The logs are still not complete.  As best I can tell, the controller
is seeing CRC errors when talking to the Fujitsu drives, but these
drives are hanging up the bus instead of responding to our ATN condition.
I believe that these drives have newer firmware available that might
aid in CRC error recovery, but you should also double check your
cable, termination, etc.

--
Justin

