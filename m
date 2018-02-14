From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Fwd: All scsi_debug devices in the scsi_debug driver share the same RAM space
Date: Tue, 13 Feb 2018 21:14:45 -0500
Message-ID: <yq11shoqpuy.fsf@oracle.com>
References: <1517686992.18584.8.camel@redhat.com>
        <1517841151.11655.1.camel@redhat.com>
        <CAM4Jq_43+JrSTvXsq7kgRLikqHb2iwFMYKTBuQjQ5h2Dn1ka+A@mail.gmail.com>
        <CAM4Jq_5yHhEWU6hvUfJVnCpyCk0QPMHhZ7cY3Eum540124ukeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57914 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966429AbeBNCOu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:14:50 -0500
In-Reply-To: <CAM4Jq_5yHhEWU6hvUfJVnCpyCk0QPMHhZ7cY3Eum540124ukeQ@mail.gmail.com>
        (Lukas Herbolt's message of "Mon, 12 Feb 2018 16:04:59 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Herbolt <lherbolt@redhat.com>
Cc: linux-scsi@vger.kernel.org


Lukas,

> I like the idea to have an option to separate the memory area for
> different LUNs, while keeping the current behavior as default.

As the name implies, scsi_debug is mostly a tool for debugging the SCSI
stack.

If you care about storing data, why not simply use target in loopback
mode?

-- 
Martin K. Petersen	Oracle Linux Engineering
