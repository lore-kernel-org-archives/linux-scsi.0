From: O & A <olgaadi@rcn.com>
Subject: kernel 2.5.18: compile time error: idedriver.o
Date: Tue, 28 May 2002 08:16:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <02052808164601.02294@linux>
Reply-To: olgaadi@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 207-237-215-126.c3-0.80w-ubr16.nyr-80w.ny.cable.rcn.com ([207.237.215.126] helo=linux)
	by smtp02.mrf.mail.rcn.net with smtp (Exim 3.33 #10)
	id 17CfjZ-0006sQ-00
	for linux-scsi@vger.kernel.org; Tue, 28 May 2002 08:05:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I got the following error when trying to compile the 2.5.18 kernel:

drivers/ide/idedriver.o: in function 'ata_module_init':
drivers/ide/idedriver.o(.text.init+0xa7b): undefined reference to 
'idescsi_init'

thanks

Adrian Gologan
