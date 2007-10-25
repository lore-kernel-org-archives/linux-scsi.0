From: Alexander Sabourenkov <screwdriver@lxnt.info>
Subject: Short INQUIRY return
Date: Thu, 25 Oct 2007 17:03:08 +0400
Message-ID: <4720940C.9040802@lxnt.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lxnt.info ([217.23.143.142]:64369 "EHLO mail.lxnt.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbXJYNqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 09:46:48 -0400
Received: from [217.23.131.8] (helo=lxnt.inside.caravan.ru)
	by mail.lxnt.info with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.68 (FreeBSD))
	(envelope-from <screwdriver@lxnt.info>)
	id 1Il2Ma-000O2i-G9
	for linux-scsi@vger.kernel.org; Thu, 25 Oct 2007 17:03:04 +0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello.


Background:
	Promise TX4 SATA300 with sata_promise driver generates lots of errors, 
both read and write.

	I'm now trying to port Promise-written driver, which works ok with 
2.6.11, to 2.6.22,
	so that I can hopefully discover the error-inducing difference between 
them, and gain
	some understanding of kernel internals in the process.

	I have somewhat cleaned up the horrible mess the Promise driver code 
is, so that it compiles,
	loads and attaches to the controller.


Problem:

	Its internal port scan prints out correct information about hard 
drive(s) discovered, and correctly
	(i think) fills out response to the INQUIRY command, but when scsi 
subsystem receives it back,
	it contains some garbage instead.

	The same code works ok on 2.6.11, and I think it would work ok up to 
2.6.16 at least, but I have not checked yet.

Question:
	Can anyone please point out some drastic change in SCSI subsystem
	(and what it would take to fix the driver up)
	that would result in such behavior, so that I can save some time 
digging it up myself?


-- 

./lxnt
