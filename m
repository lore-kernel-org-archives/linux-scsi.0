From: Michael Pavlovsky <spavlov@t2.technion.ac.il>
Subject: Re: Help - interface between Linux SCSI mid-level driver and lower-level
 driver
Date: Fri, 26 Mar 2004 12:14:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40640289.3030804@t2.technion.ac.il>
References: <519672568F040C41B6FAC21ADF51B18FF7C8@mailnode1.commstor.crossroads.com>
Reply-To: spavlov@t2.technion.ac.il
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw3.technion.ac.il ([132.68.238.35]:28555 "EHLO
	mailgw3.technion.ac.il") by vger.kernel.org with ESMTP
	id S264007AbUCZKku (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 05:40:50 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mailgw3.technion.ac.il (Postfix) with ESMTP id 5F1F2167788
	for <linux-scsi@vger.kernel.org>; Fri, 26 Mar 2004 12:14:53 +0200 (IST)
	(envelope-from spavlov@t2.technion.ac.il)
Received: from mailgw3.technion.ac.il ([127.0.0.1])
 by localhost (mailgw3.technion.ac.il [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 04210-01-83 for <linux-scsi@vger.kernel.org>;
 Fri, 26 Mar 2004 12:14:52 +0200 (IST)
Received: from t2.technion.ac.il (t2.technion.ac.il [132.68.0.102])
	by mailgw3.technion.ac.il (Postfix) with ESMTP id 6FC0816777B
	for <linux-scsi@vger.kernel.org>; Fri, 26 Mar 2004 12:14:52 +0200 (IST)
	(envelope-from spavlov@t2.technion.ac.il)
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FF7C8@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@crossroads.com>
Cc: linux-scsi@vger.kernel.org

Hi,
    I am working on something similar ( over InfiniBand)
I have no experiance with scsi subsystem and I am gothering any peace of
information about mid-core layer interface towards higher layers.
I hope next may help to you, and if you know more please publish it.
In order to activate mid layer you should call scsi_allocate_device 
after that
choose the right device from linked list and fill scsi_command struct
register it , and call scsi_do_command
I am going to write some code soon so I hope I would undertstand better.
For now the best source of information for me is 
http://www.andante.org/scsi.html
it is sucks ( just data structures and not complete)
and take unh-iscsi from sf.net they have scsi_target.{c,h} it is ~1500 
lines of code and readable

please write me if you know more.


Michael


Lee Xing wrote:

>Hi,
>
>I'm not SCSI driver expert.  Sorry for asking simple questions here.  Your help would be appreciated.
>
>We are working on a new prototype that uses a FC HBA on Linux.  Our FC driver detects the physical FC disks as SCSI devices and reports them to a higher_layer (not Linux SCSI mid-level driver) in Linux kernel.  Now, we need to create another layer that sits in between the existing higher_layer and Linux SCSI mid-level driver, and to register the detected FC/SCSI devices as Linux sd/sg devices.
>
>My question is what are the interface functions in SCSI mid-level driver we can invoke to register the detected FC/SCSI devices as Linux sg/sd devices.  Sample code and documents would be a great help.
>
>Thanks,
>
>
>L.
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>


-- 
--
"If everybody minded their own business," the Duchess 
said in a hoarse growl, "the world would go round a 
deal faster than it does".

	Lewis Carroll (1832--98), English author,mathematician.
 	Alice's Adventures in Wonderland, ch. 6 (1865).

