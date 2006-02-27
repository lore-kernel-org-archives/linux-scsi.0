From: "erich" <erich@areca.com.tw>
Subject: Re: Areca RAID driver remaining items?
Date: Mon, 27 Feb 2006 19:27:33 +0800
Message-ID: <001401c63b90$cf646370$b100a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 220-130-178-143.HINET-IP.hinet.net ([220.130.178.143]:64488
	"EHLO areca.com.tw") by vger.kernel.org with ESMTP id S1751151AbWB0L1t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 06:27:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "\"erich\"" <erich@areca.com.tw>, "\"Arjan van de Ven\"" <arjan@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, akpm@osdl.org, oliver@neukum.org

Dear Christoph Hellwig,

Do you have any comments with arcmsr SATA RAID driver on sysfs attribute?
There were four types of function template completed in linux.
iscsi_function_template
sas_function_template
spi_function_template
fc_function_template
Do you have opintion with "arcmsr_transport_functions" ?
and Which function templete does "arcmsr" belong to?

Best Regards
Erich Chen

