From: Mark Rustad <mrustad@mac.com>
Subject: Adaptec HostRAID for 7902 in 2.6 kernel series
Date: Mon, 20 Dec 2004 17:51:31 -0600
Message-ID: <12EA9733-52E2-11D9-B13A-0003934F6348@mac.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout.mac.com ([17.250.248.85]:51427 "EHLO smtpout.mac.com")
	by vger.kernel.org with ESMTP id S261718AbULTXvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 18:51:37 -0500
Received: from mac.com (smtpin02-en2 [10.13.10.147])
	by smtpout.mac.com (Xserve/MantshX 2.0) with ESMTP id iBKNpa6B005538
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2004 15:51:36 -0800 (PST)
Received: from [10.64.43.12] ([216.245.167.136])
	(authenticated bits=0)
	by mac.com (Xserve/smtpin02/MantshX 4.0) with ESMTP id iBKNpY8Y010713
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2004 15:51:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Folks,

Is there any support for the Adaptec 7902 HostRAID operation using the 
2.6 kernel series? I have seen the binary modules on the Adaptec site 
for the 2.4 kernels and I have tried various 2.6 kernels. Some of the 
2.6 kernels do not see the device when it is set up for HostRaid, 
others see the underlying raw devices, which doesn't seem right.

Is this pilot error, or is there simply no support yet on 2.6? If not, 
does anyone know when there will be support?

-- 
Mark Rustad, MRustad@mac.com

