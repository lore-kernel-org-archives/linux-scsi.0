From: Louay Gammo <lgammo@cs.uwaterloo.ca>
Subject: Aic7x_x_x 6.2.36 && Aic79xx 1.3.10 Updates
Date: Thu, 13 Nov 2003 14:42:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB3DEBD.5050306@cs.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bbcr.uwaterloo.ca ([129.97.34.2]:28644 "EHLO bbcr.uwaterloo.ca")
	by vger.kernel.org with ESMTP id S264415AbTKMTlI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 14:41:08 -0500
Received: from cs.uwaterloo.ca (lato.cs.uwaterloo.ca [129.97.75.210])
	(authenticated (0 bits))
	by bbcr.uwaterloo.ca (8.11.7/8.11.7) with ESMTP id hADJf7q03422
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2003 14:41:07 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Has any one succeeded in running the latest  sources with RH9 (2.4.20-8) 
kernel? Specifically, these are the sources sent out by Justin T. Gibbs 
<http://groups.google.com/groups?hl=en&lr=&ie=UTF-8&q=author:gibbs%40scsiguy.com+> 
(gibbs@scsiguy.com <mailto:gibbs%40scsiguy.com>):

    http://people.FreeBSD.org/~gibbs/linux/SRC/
<http://people.FreeBSD.org/%7Egibbs/linux/SRC/>
In my case the driver loads fine, but it takes a while to initialize(?). 
I get errors like:
scsi0: Host status: Failed(0)
...

The kernel boots fine, and the rc scripts are run fine and the console 
prompt shows fine. However, the console is locked. I cannot type 
anything there.  I can ssh/telnet to the machine. The disks seem to be 
accessed fine. However, I get the same errors from the driver on shutdown.

So before I waste my time and (more importantly) yours, does this sound 
familiar or did I miss something in the compile. I will send a more 
complete screen dump if anyone is interested.

Thanks a lot,

L.





