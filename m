From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Suggestions for testing SAS cables via sg3_utils
Date: Wed, 18 Mar 2015 12:25:03 -0700
Message-ID: <5509D10F.2020601@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35369 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbbCRTZE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2015 15:25:04 -0400
Received: by obcjt1 with SMTP id jt1so19594163obc.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2015 12:25:04 -0700 (PDT)
Received: from cloudberry-sbg.corp.aeoncomputing.com ([12.226.163.194])
        by mx.google.com with ESMTPSA id h4sm11613230obr.18.2015.03.18.12.25.03
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Mar 2015 12:25:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Greetings,

Does anyone have an effective way of testing SAS cabling in a Linux
environment without using a block storage device?

Something like reading/writing to a buffer in an expander (LSI). Something
that could stress all four lanes of a multilane cable. Like a SAS 
equivalent of a floodping between a SAS initiator and a SAS expander to 
stress the cable.

Thanks,

--Jeff

-- 
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff dot johnson at aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x1001

4170 Morena Boulevard, Suite D - San Diego, CA 92117

High-performance Computing / Lustre Filesystems / Scale-out Storage

