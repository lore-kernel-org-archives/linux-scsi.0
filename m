From: Mark Bellon <mbellon@mvista.com>
Subject: Re: Problems with updated firmware for qla2xxx driver.
Date: Tue, 23 Mar 2004 15:50:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4060BF1E.6050206@mvista.com>
References: <B179AE41C1147041AA1121F44614F0B0DCFFB3@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:20719 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S262902AbUCWWuQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 17:50:16 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DCFFB3@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "Caushik, Ramesh" <ramesh.caushik@intel.com>, linux-scsi@vger.kernel.org

With the 2.4 version of the driver I had problems with some Intel ATCA 
prototypes (1 or 2 out of 5). There is a hardware issue that required a 
respin for one fix and I think there is one outstanding issue as well. 
You should find out if you board has the "power rail" respin (or a "blue 
wire" workaround).

mark


