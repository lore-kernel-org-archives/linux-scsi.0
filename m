From: =?ISO-8859-1?Q?=22Mauricio_R=2E_P=E9rez=22?=
	<linuxadm@pergamino.gov.ar>
Subject: kernel 2.6.9 and megaraid and sym53c8xx on HP Netserver LH4
Date: Fri, 03 Dec 2004 17:32:01 -0300
Message-ID: <41B0CD41.9070306@pergamino.gov.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 200-112-131-37.bbt.net.ar ([200.112.131.37]:30132 "EHLO
	mail.pergamino.gov.ar") by vger.kernel.org with ESMTP
	id S262502AbULCUcJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2004 15:32:09 -0500
Received: from localhost (pergamino.gov.ar [127.0.0.1])
	by mail.pergamino.gov.ar (Postfix) with ESMTP id 10FBFA3810
	for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2004 17:32:18 -0300 (ART)
Received: from mail.pergamino.gov.ar ([127.0.0.1])
 by localhost (server.pergamino.gov.ar [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 17578-01 for <linux-scsi@vger.kernel.org>;
 Fri,  3 Dec 2004 17:32:17 -0300 (ART)
Received: from [10.175.60.100] (unknown [10.175.60.100])
	by mail.pergamino.gov.ar (Postfix) with ESMTP id 912789EAC4
	for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2004 17:32:17 -0300 (ART)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, i've tried to install kernel 2.6.9, but it doesn't even starts 
megaraid, it hangs on start, kernel 2.4.26 is working, but sym53c8xx 
doesnt loads...
