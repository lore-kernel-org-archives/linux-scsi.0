From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [SUBJECT CHANGE]: megaraid unified driver version
 2.20.0.0-alpha1
Date: Tue, 24 Feb 2004 20:27:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224202750.4a35a199.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:34745 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262463AbUBYEb1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 23:31:27 -0500
List-Id: linux-scsi@vger.kernel.org
To: atulm@lsil.com
Cc: linux-scsi@vger.kernel.org


<quote:>
All,

Here is the list of enhancements this driver has build over the current
2.10.1 driver. Please list you specific concerns so that the driver can be
modified accordingly. This is an updated version of the current driver in lk
2.6, which should take all your fixes, instead of current 2.00.3 in 2.6.2
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Hi,

Does it fix this one (from 2.6.3), for CONFIG_PROC_FS=n ?

/mnt/box/linux-263-223-kj1/drivers/scsi/megaraid.c:4934: undefined reference to `mega_create_proc_entry'

--
~Randy
