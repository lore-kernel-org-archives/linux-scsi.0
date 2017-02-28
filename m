From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: close hole in > 2T device rejection when !CONFIG_LBDAF
Date: Mon, 27 Feb 2017 22:18:28 -0500
Message-ID: <yq1wpcbvw8r.fsf@oracle.com>
References: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
        <1488211985.2656.1.camel@sandisk.com>
        <3a6783ec-200d-5df5-2e1e-756c7e8b7c22@digidescorp.com>
        <1488221849.2656.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:19629 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdB1DVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 22:21:49 -0500
In-Reply-To: <1488221849.2656.8.camel@sandisk.com> (Bart Van Assche's message
        of "Mon, 27 Feb 2017 18:57:44 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "steve.magnani@digidescorp.com" <steve.magnani@digidescorp.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "steve@digidescorp.com" <steve@digidescorp.com>

>>>>> "Bart" == Bart Van Assche <Bart.VanAssche@sandisk.com> writes:

Bart,

Bart> Sorry but I still don't understand why the two checks are
Bart> different. How about the (untested) patch below? The approach
Bart> below avoids that the check is duplicated and - at least in my
Bart> opinion - results in code that is easier to read.

I'll take a closer look at your patch tomorrow. I am sympathetic to
having a sanity check helper function. That would also give us a single
place to filter out crackpot values reported by USB doodads.

-- 
Martin K. Petersen	Oracle Linux Engineering
