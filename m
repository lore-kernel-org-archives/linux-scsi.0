From: Danny Leong <danny@trek2000.com.sg>
Subject: Advice on getting the scsi device name.
Date: 04 Jun 2004 10:48:16 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086317300.1023.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rhea.webvis.net ([202.157.145.2]:19674 "EHLO trek2000.com.sg")
	by vger.kernel.org with ESMTP id S263740AbUFDCrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2004 22:47:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, 

 I am writing a program that needs to safely and correctly identify and
mount a dev/sda ... dev/sda1 or dev/sdb etc.As far my knowledge fits me,
i have to manually check the entry on proc/scsi/scsi to determine.
Please advice me on a better method that could be included in a C
program. Any help is greatly appreciated. 

- Thanks :) 
Danny


  



