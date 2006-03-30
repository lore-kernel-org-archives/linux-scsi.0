From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Cannot open root device?
Date: Thu, 30 Mar 2006 10:40:20 -0500
Message-ID: <1143733221.8777.1.camel@localhost.localdomain>
References: <442BFA2E.7090907@gmail.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:53434 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S1751154AbWC3Pke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 10:40:34 -0500
In-Reply-To: <442BFA2E.7090907@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bo Yang <struggleyb@gmail.com>
Cc: linux-scsi@vger.kernel.org

u asked in a wrong list. this is a kernel recompilation&installation
question. please go kernel newbie list
http://www.kernelnewbies.org/mailinglist.php3

Ming



On Thu, 2006-03-30 at 23:33 +0800, Bo Yang wrote:
> Hello everybody :
> I know maybe my question is just a piece of cake for you , but
> I have struggled with it for 4 days , and I didn't get any answer from
> the google and the archive .
> So I came here !
> 
> And my problem is that :
> I use VMware , and install gentoo linux on the vm which hold a scsi disk
> . I compile the linux kernel with scsi support in the kernel self , but
> when boot up the kernel panic with the bellow message :
> VFS: Cannot open root device "803" or unkonw-block(8,3)
> Please append a correct "root=" boot option
> 
> But I have a line in my lilo.conf : root=/dev/sda3
> 
> I have recompile the kernel for many times , but it panic everytime .
> 
> Thanks in advance !
> 
> Best Regard !
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

