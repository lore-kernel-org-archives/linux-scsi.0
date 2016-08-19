From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Bug 153171] New: scsi host6: runtime PM trying to activate child device host6 but parent (2-2:1.0) is not active
Date: Thu, 18 Aug 2016 22:17:51 -0400
Message-ID: <yq1fuq1ijsg.fsf@sermon.lab.mkp.net>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
        <87520866-b206-c938-6cda-e2f1c9f85f6b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36269 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753514AbcHSCR7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2016 22:17:59 -0400
In-Reply-To: <87520866-b206-c938-6cda-e2f1c9f85f6b@gmail.com> (Heiner
        Kallweit's message of "Mon, 15 Aug 2016 22:04:16 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Heiner" == Heiner Kallweit <hkallweit1@gmail.com> writes:

Heiner> This issue is fixed by patch scsi: "core: configure runtime pm
Heiner> before calling device_add in scsi_add_host_with_dma" I sent on
Heiner> Aug 3rd.

Severely lacking in the reviews department, though :(

-- 
Martin K. Petersen	Oracle Linux Engineering
