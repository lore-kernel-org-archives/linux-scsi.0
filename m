From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Mon, 05 Dec 2016 17:04:13 -0500
Message-ID: <yq1bmwqvxr6.fsf@sermon.lab.mkp.net>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15>
        <CAFqt6zbQn4YivsKG3X5Y2OWK92LaUk5nbe+oUheF111ZONULOw@mail.gmail.com>
        <CAFqt6zbx45Gx4fN4Hv6PZLGsQB8FEK=mjxwAYVNDEpKbOZR+7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19098 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbcLEWE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 17:04:28 -0500
In-Reply-To: <CAFqt6zbx45Gx4fN4Hv6PZLGsQB8FEK=mjxwAYVNDEpKbOZR+7g@mail.gmail.com>
        (Souptick Joarder's message of "Mon, 5 Dec 2016 11:56:22 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Rameshwar Sahu <sahu.rameshwar73@gmail.com>, linux-scsi@vger.kernel.org

>>>>> "Souptick" == Souptick Joarder <jrdr.linux@gmail.com> writes:

Souptick,

Souptick> Any comment on this patch?

The patch looked OK to me when you posted it. However, you need one
person in addition to me to review it. And you need convince us of the
merit of a presumably untested change to an unmaintained driver.

-- 
Martin K. Petersen	Oracle Linux Engineering
