From: Ivo Santos Cavalcante Carneiro <iscc_listadisc@ig.com.br>
Subject: unable to mount cdrom/cdrw using scsi emulation
Date: Fri, 19 Sep 2003 14:39:23 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F6B3F4B.8080503@ig.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-26.ig.com.br ([200.226.132.160]:23456 "HELO
	smtp-26.ig.com.br") by vger.kernel.org with SMTP id S261651AbTISRkd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2003 13:40:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>



Sorry, I'm not sure this is the right place to send this, but case not,
please discard this mail.


I'm having some problem when trying to mount cdrom: I receive an error
message and am still unable to read from cd at the mount point.
It's possible to execute a music disc from the drives.
I've a cdrom drive and a cdrw drive and none of them work. All two drives
work fine using ide-cd (ATAPI) driver.

I've made a complete bug report, but I'm not sure this is the case, so this
mail contain only the error messages.

P.S.: sorry by the poor english.

TIA,
Ivo


These are the messages retrieved from kernel log:

********
Aug 31 19:50:43 serv kernel: ide-scsi: The scsi wants to send us more 
data than expected - discarding data
Aug 31 19:50:43 serv kernel: ide-scsi: [[ 28 0 0 0 0 10 0 0 1 0 0 0 ]
Aug 31 19:50:43 serv kernel: ]
Aug 31 19:50:43 serv kernel: ide-scsi: expected 2048 got 4096 limit 2048
********


This message appear many times on kern.log - I've noticed a number, on the
second line, changing from 10 to 63 in hexadecimal notation. The number is
shown below (between arrows):

********
Aug 31 19:50:43 serv kernel: ide-scsi: [[ 28 0 0 0 0 ->10<- 0 0 1 0 0 0 ]
********


So, this is the last repeated message on kernel log:

********
Aug 31 19:50:43 serv kernel: ide-scsi: The scsi wants to send us more 
data than expected - discarding data
Aug 31 19:50:43 serv kernel: ide-scsi: [[ 28 0 0 0 0 63 0 0 1 0 0 0 ]
Aug 31 19:50:43 serv kernel: ]
Aug 31 19:50:43 serv kernel: ide-scsi: expected 2048 got 4096 limit 2048
********


After that, I receive this message:

********
Aug 31 19:50:43 serv kernel: Unable to identify CD-ROM format.
********


