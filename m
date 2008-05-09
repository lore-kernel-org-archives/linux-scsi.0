From: Rakesh <raksac@yahoo.com>
Subject: Re: megaraid_sas: direct drive access for smartctl and hdparm
Date: Fri, 9 May 2008 16:01:59 -0700 (PDT)
Message-ID: <303173.13389.qm@web30207.mail.mud.yahoo.com>
Reply-To: raksac@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30207.mail.mud.yahoo.com ([209.191.69.54]:38208 "HELO
	web30207.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751316AbYEIXCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 19:02:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>>  I was trying to get some useful SMART Information from the SATA 
>> drives connected to my PERC5/i controller, but the PERC had no 
>> options for that.

I would say use the mptctl interface to do anything you would like to do with the physical members of the RAID device

Thanks,
Rakesh



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
