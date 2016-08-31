From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: Fix the search of first memory bar
Date: Tue, 30 Aug 2016 22:23:34 -0400
Message-ID: <yq1lgzd7k2h.fsf@sermon.lab.mkp.net>
References: <1471768105-14730-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29539 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754214AbcHaCXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2016 22:23:43 -0400
In-Reply-To: <1471768105-14730-1-git-send-email-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 21 Aug 2016 10:28:25 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Christophe" == Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

Christophe> The 2nd parameter of 'find_first_bit' is the number of bits
Christophe> to search.  In this case, we are passing 'sizeof(unsigned
Christophe> long)' which is likely to be 4.

Christophe> It is likely that the number of bits in a long was expected
Christophe> here, so use BITS_PER_LONG instead.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
