From: "Richard Cai" <richardc@sz.webex.com>
Subject: the problem about a320raid driver
Date: Tue, 18 Jan 2005 17:39:03 +0800
Message-ID: <389C46D66D1FEC4FA5B03A781A29580B802F0F@mailserver.sz.webex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [218.4.150.161] ([218.4.150.161]:12839 "EHLO sz.webex.com")
	by vger.kernel.org with ESMTP id S261207AbVARJjE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 04:39:04 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi
   I am using intel SE7501WV2 server, with a AIC 7902(A) SCSI control , a320raid driver. OS is redhat 8.0 , kernel is 2.4.18-14. if I run lsmod, it showes the a320raid module is right. Now I want to recompile to kernel , but every time when I run the command make install, it will prompt : "No module a320raid found for kernel 2.4.18-14custom " . Who can lead me a right way ? thanks. 

Richard

