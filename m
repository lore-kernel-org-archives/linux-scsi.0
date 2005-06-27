From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] 2.6 aacraid: shutdown notification (update)
Date: Mon, 27 Jun 2005 10:00:48 -0500
Message-ID: <42C014A0.3050301@us.ibm.com>
References: <1119883177.22704.12.camel@markh1.pdx.osdl.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:31118 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262077AbVF0PAz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 11:00:55 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5RF0pco040600
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2005 11:00:51 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5RF0ocC174242
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2005 09:00:50 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5RF0nVR032567
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2005 09:00:50 -0600
In-Reply-To: <1119883177.22704.12.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Mark Haverkamp wrote:

> @@ -867,6 +876,9 @@ static struct pci_driver aac_pci_driver 
>  	.id_table	= aac_pci_tbl,
>  	.probe		= aac_probe_one,
>  	.remove		= __devexit_p(aac_remove_one),
> +	.driver		= {
> +		.shutdown = aac_shutdown,
> +	},
>  };

Sorry to nitpick, but there is a shutdown function pointer in the
pci_driver struct now (not just in the device_driver struct) that all
drivers should probably be migrating to.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
