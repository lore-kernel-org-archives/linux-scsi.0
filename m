From: Bo Yang <struggleyb@gmail.com>
Subject: Cannot open root device?
Date: Thu, 30 Mar 2006 23:33:02 +0800
Message-ID: <442BFA2E.7090907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.206]:44195 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751029AbWC3PdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 10:33:11 -0500
Received: by zproxy.gmail.com with SMTP id o37so493871nzf
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 07:33:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everybody :
I know maybe my question is just a piece of cake for you , but
I have struggled with it for 4 days , and I didn't get any answer from
the google and the archive .
So I came here !

And my problem is that :
I use VMware , and install gentoo linux on the vm which hold a scsi disk
. I compile the linux kernel with scsi support in the kernel self , but
when boot up the kernel panic with the bellow message :
VFS: Cannot open root device "803" or unkonw-block(8,3)
Please append a correct "root=" boot option

But I have a line in my lilo.conf : root=/dev/sda3

I have recompile the kernel for many times , but it panic everytime .

Thanks in advance !

Best Regard !


