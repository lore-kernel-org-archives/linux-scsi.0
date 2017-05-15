From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: fix sysfs writes to "provisioning_mode" and "zeroing_mode"
Date: Mon, 15 May 2017 17:18:10 -0400
Message-ID: <yq1mvades4t.fsf@oracle.com>
References: <1494875606-6298-1-git-send-email-emilne@redhat.com>
        <1494879289.2567.3.camel@sandisk.com>
        <1494882178.1081.43.camel@localhost.localdomain>
        <1494882849.2567.6.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40127 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757876AbdEOVS2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 17:18:28 -0400
In-Reply-To: <1494882849.2567.6.camel@sandisk.com> (Bart Van Assche's message
        of "Mon, 15 May 2017 21:14:10 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "emilne@redhat.com" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Bart,

>> So, are you suggesting we change all the other sysfs store routines?
>
> I will leave it to Martin and James to comment on this.

As I mentioned a few weeks ago, I have a patch that converts all these
to sysfs_match_string(). Now that the latter is upstream I intend to
post the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
