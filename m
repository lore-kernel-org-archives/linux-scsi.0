From: "Aleks Sheynkman" <aleks@Narus.com>
Subject: quite ion about megraid-2.10.3
Date: Fri, 11 Jun 2004 10:27:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FA6D803197D0E14C88E1B74C5A021B822DDD6A@snitch.narus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.narus.com ([66.236.101.211]:20361 "EHLO mx2.narus.com")
	by vger.kernel.org with ESMTP id S264226AbUFKR1l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 13:27:41 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org, mailman-owner@us.dell.com

Hi Matt,
  I have a 6650 that running RH 7.3 2.4.18-17.7xbigmem kernel with 1.8f
version of megraid driver, I am trying to upgrade it to megraid-2.10.3.
As Atul suggested I change it .can_do_varyio =1 and also my kernel was
not patch so I had to change host_lock to use io_request_lock in adapter
unitization. So I compile the driver and create a new initrd image
,every time my system boot up I see following , drivers seems to load
find I see first message which was produced by mega_find_card() routine

 scsi0:SI Logic MegaRAID 1.72.25 commands 16 targs 5 chans 7 luns

 then I see second message

 scsi1LSI Logic MegaRAID 1.72.25 commands 16 targs 5 chans 7luns, 

and it hangs after that. One interpreting thing is 
that it kind of sitting and waiting for something , because I 
can input from keyboard. Also If I press  Cntrl -Alt -Delete it start a
shutdown process, it trying to 
flush a raid cache etc.

Did anyone ever see or experience this problem before.

Thanks a lot for you help !!!

-Aleks
