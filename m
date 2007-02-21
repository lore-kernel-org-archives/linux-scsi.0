From: John Scarpa <john@tlchosting.com>
Subject: Please help if u can.
Date: Tue, 20 Feb 2007 20:16:57 -0500
Message-ID: <45DB9D89.7030804@tlchosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tlchosting.com ([209.170.84.20]:3950 "HELO
	mail.tlchosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932348AbXBUBYB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 20:24:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear Luben,

I am trying to compile the aic94xx for my aic9410 directly into my 
kernel (fc5_64bit-2.6.20)...  Is this possible or must it be loaded as a 
module?  I am really not wanting to add modular support to my nice neat 
monolithic kernel.. :-(  I've been searching for ever now and tried 
everything i could to no avail..

--->Log
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:04:02.0
scsi0 : aic94xx
aic94xx: Failed to load sequencer firmware file aic94xx-seq.fw, error -2
aic94xx: couldn't init seqs for 0000:04:02.0
aic94xx: couldn't init the chip

--->Specs
FC5_64bit 2.6.20
Supermicro 6025B-3 Server Model



Thank you for any help!  btw this is the first time i ever wrote a 
maintainer for help... my pride is definitely hurting right now...

Best wishes,
John Scarpa

