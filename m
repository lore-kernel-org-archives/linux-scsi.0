From: "english" <english@ms1.dhps.ylc.edu.tw>
Subject: Building AIC94xx driver
Date: Mon, 11 Sep 2006 12:01:35 +0800
Message-ID: <20060911034952.M44911@ms1.dhps.ylc.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=big5
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms1.dhps.ylc.edu.tw ([163.27.227.1]:14518 "EHLO
	ms1.dhps.ylc.edu.tw") by vger.kernel.org with ESMTP
	id S1750703AbWIKDjH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Sep 2006 23:39:07 -0400
Received: from ms1.dhps.ylc.edu.tw (ms1 [127.0.0.1])
	by ms1.dhps.ylc.edu.tw (Postfix) with ESMTP id 9F0D8126D210
	for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2006 12:01:35 +0800 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everyone, 

My name is Ray Liao. I wish to help testing out the AIC94xx driver. 
I cloned the aic94xx development tree via git and tried compiling it.
The compilation completed without any error. However, when i try to
load the driver-- i received the following error message :

aic94xx: Failed to load sequencer firmware file aic94xx-seq.fw, error -2

I looked around the source code and can't find the firmware file it speaks
of. 

Can someone tell me where i will be able to find this file?

Thanks in advance for your help,

Ray Liao

--
Open WebMail Project (http://openwebmail.org)

