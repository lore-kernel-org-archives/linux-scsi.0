From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 06 Mar 2017 22:46:47 -0500
Message-ID: <yq1lgshkau0.fsf@oracle.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
        <e13aeaf9-3b2c-a9e8-5867-cf9ab20a040c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47039 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdCGDrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 22:47:02 -0500
In-Reply-To: <e13aeaf9-3b2c-a9e8-5867-cf9ab20a040c@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Mon, 6 Mar 2017 11:52:36
        -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@ozlabs.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, benh@kernel.crashing.org, jk@ozlabs.org, linux-scsi@vger.kernel.org

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio> On 02/12/2017 07:49 PM, Anton Blanchard wrote:
>> We see lpfc devices regularly fail during kexec. Fix this by adding a
>> shutdown method which mirrors the remove method.

Mauricio> @mkp, @jejb: may you please flag this patch for stable?  Thank
Mauricio> you.

I don't recall a consensus being reached on this patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
