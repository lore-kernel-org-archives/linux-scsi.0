From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: iscsi (?): Unknown VPD Code: 0xc7
Date: Thu, 23 Mar 2017 15:59:02 -0400
Message-ID: <yq1r31ndat5.fsf@oracle.com>
References: <5cab3767-c2c8-7934-a3e8-c31d7abdf2ea@aixigo.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45849 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbdCWT7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 15:59:17 -0400
In-Reply-To: <5cab3767-c2c8-7934-a3e8-c31d7abdf2ea@aixigo.de> (Harald Dunkel's
        message of "Thu, 23 Mar 2017 20:27:03 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Dunkel <harald.dunkel@aixigo.de>
Cc: linux-scsi@vger.kernel.org

Harald Dunkel <harald.dunkel@aixigo.de> writes:

> Mar 23 19:06:30 nasl003b kernel: [38396.624678] Unknown VPD Code: 0xc7
>
> What is it trying to tell me?

That is an IBM-specific VPD page containing device-unique configuration
data. I guess it is a prerequisite for installing AIX.

-- 
Martin K. Petersen	Oracle Linux Engineering
