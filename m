From: "mel" <mel@mmtab.se>
Subject: Promise UltraTrak RM15000 + Adaptec 39160
Date: Fri, 8 Aug 2003 12:36:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808103621.M63039@mmtab.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.209.150.83] ([212.209.150.83]:2956 "EHLO mail.mmtab.se")
	by vger.kernel.org with ESMTP id S271116AbTHHKi7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 06:38:59 -0400
Received: from mmtab.se (localhost.localdomain [127.0.0.1])
	by mail.mmtab.se (8.12.9/8.12.9) with ESMTP id h78AaLMw028336
	for <linux-scsi@vger.kernel.org>; Fri, 8 Aug 2003 12:36:21 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The story so far:

I've been running an out of the box RH 7.3 with 2.4.18-3 kernel together with 
the 39160 card and a UltraTrak RM8000 for over 12 months. The only change 
made to the kernel was that I compiled the aic7xxx driver into the kernel. 
The server is running nfs and samba only. The RM8000 is equipped with eight 
80GB IBM drives and exports about 0.5TB.

The mobo is a Kinetiz 7E-A with a 1GHz AMD and 512MB of RAM.

When we run out of disk i invested in a RM15000 and 15 120GB IBM-drives. I 
figured it was time to upgrade kernel and drivers and therefore I got the 
2.4.21 kernel together with the latest driver ( aic79xx-linux-2.4-20030603-
tar.gz )  from Justin Gibbs site http://people.freebsd.org/~gibbs/linux/

After installation I tried to partition and makefs the new drive. I got a lot 
of parity errors and "trying to queue an ABORT message" from the card. I did 
some 'Googling' but could not find the answer.

As the server is in production I assembled a lab machine and hooked the 
RM15000 to that machine. I did a RH7.3 install and had it to autodetect my 
gear ( aic7xxx as a module ). As a surprise everything worked without a 
glitch with this setup. I tried to use the 2.4.21 kernel with the new driver 
( as a module ) on this machine but with this it malfunctioned in the same 
way as before.

Is there anyone that have a clue to this behaviour?

Shouldn't the never version be better ;)

/Mel

--

This sentence is false.
