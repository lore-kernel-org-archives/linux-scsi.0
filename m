From: "Qi, Yanling" <yqi@lsil.com>
Subject: An array failover driver
Date: Thu, 19 Dec 2002 15:56:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <EB1DF7EA0D32D611B79C0002A51363F194A7BE@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mhbs.lsil.com (mhbs.lsil.com [147.145.31.100])
	by mail0.lsil.com (8.12.4/8.12.4) with ESMTP id gBJJaaCj004516
	for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2002 13:56:18 -0800 (PST)
Received: from [153.79.12.11] by mhbs.lsil.com with ESMTP for linux-scsi@vger.kernel.org; Thu, 19 Dec 2002 13:56:07 -0800
List-Id: linux-scsi@vger.kernel.org
To: 'linux-scsi-reflector' <linux-scsi@vger.kernel.org>

Hi All, 

I am going to develop a multiple-pathing driver to support our storage array
hardware on Linux(2.4 and later). I prefer the driver sit on the top of HBA
drivers (fibre channel adapter drivers) and below middle level (the unifying
layer). In other words, insert my pseudo driver into middle level and lower
level drivers. The driver will take care of path failover. I am still in
research phase. Do you have any suggestions?

  
Thanks, 
  
Yanling Qi 
