From: "Ujval Lodha" <ujval@gdc-tech.com>
Subject: Writing to tape from C system calls
Date: Fri, 12 Dec 2003 20:39:06 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <035701c3c0ac$f1ccbae0$aa00a8c0@ASTERIX>
References: <033701c3c0ac$97659270$aa00a8c0@ASTERIX>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [203.132.205.66] ([203.132.205.66]:56544 "EHLO
	helium.gdc-tech.com") by vger.kernel.org with ESMTP id S264556AbTLLMjR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 07:39:17 -0500
Received: from ASTERIX ([192.168.0.170])
	(authenticated)
	by helium.gdc-tech.com (8.11.6/8.11.0) with ESMTP id hBCCZSa15989
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2003 20:35:29 +0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi

I'm new to tape devices.

My application requires me to seek to a certain block on the tape device and
write data on it (besides being able to retrieve data by reading).

So far, I have no trouble reading from the tape.

When I write to it at any block that block becomes the last block on the
device. I am unable to seek to any block after that on the tape. I have
tried :

    a. Using mt to seek and dd to write
    b. Using open / ioctl / write from C

Both with the same results. I am using a Tandberg SDLT for my tests with the
linux kernel st drivers.

Is this normal? Is it not possible to use the tape device - and modify data
at any block by seeking to it and writing?

Is there some source of information where I can read about programming tape
devices from C? So far, I havent been able to find one.

Please advise.
Regards,
Ujval Lodha



