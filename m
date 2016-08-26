From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] ipr: Add asynchronous error notification
Date: Thu, 25 Aug 2016 22:47:52 -0400
Message-ID: <yq1zio09rfr.fsf@sermon.lab.mkp.net>
References: <1469795977-6345-1-git-send-email-halves@linux.vnet.ibm.com>
        <yq1twehh3ty.fsf@sermon.lab.mkp.net>
        <a7eec861-46e1-4d82-1361-ae9b9a04cf3d@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25191 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbcHZCr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2016 22:47:58 -0400
In-Reply-To: <a7eec861-46e1-4d82-1361-ae9b9a04cf3d@linux.vnet.ibm.com> (Brian
        King's message of "Wed, 24 Aug 2016 12:56:51 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Heitor Ricardo Alves de Siqueira <halves@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Heitor Ricardo Alves de Siqueira <hrasiq@gmail.com>, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> Looks pretty good. I noticed one issue in an error path where you
Brian> weren't removing the new sysfs file. Here is a fixed version.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
