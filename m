From: Zaigham Faraz Siddiqui <zaigham61@yahoo.com>
Subject: Data Overrun Error?
Date: Wed, 7 Sep 2005 07:54:27 +0100 (BST)
Message-ID: <20050907065427.90252.qmail@web30504.mail.mud.yahoo.com>
Reply-To: zaigham16@hotmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30504.mail.mud.yahoo.com ([68.142.200.117]:24171 "HELO
	web30504.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751021AbVIGGyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 02:54:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi,
the virtual scsi device is hosted on Linux 2.4 and
solaris 10 (x86) is the initiator. Disk formating and
mountig is working fine but as soon as we try and run
dd 1Gb.... the initiartor copies around 41Mb and after
that 'data overrun' ctio-error is recieved on the
target side (qla2300)... we are extracting information
like data length and lun from the atio/iocb... scsi
cdb is also giving the same parameters... can some one
advise me why exactly is the error coming? can it be
due to mis-calculated data length on the target side?


	
	
		
___________________________________________________________ 
Yahoo! Messenger - NEW crystal clear PC to PC calling worldwide with voicemail http://uk.messenger.yahoo.com
