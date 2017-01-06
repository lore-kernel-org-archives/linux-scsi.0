From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Thu, 05 Jan 2017 20:59:57 -0500
Message-ID: <yq1y3ypgd7m.fsf@oracle.com>
References: <20161229080250.GA11605@infradead.org>
        <1483226343.2518.32.camel@linux.vnet.ibm.com>
        <1483280506.5512.1.camel@sandisk.com>
        <20170101.113311.417107391370623850.davem@davemloft.net>
        <1483292364.2345.5.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:50879 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbdAFCCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 21:02:09 -0500
In-Reply-To: <1483292364.2345.5.camel@linux.vnet.ibm.com> (James Bottomley's
        message of "Sun, 01 Jan 2017 09:39:24 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, Bart.VanAssche@sandisk.com, hch@infradead.org, jbaron@akamai.com, linux-kernel@vger.kernel.org, sagi@grimberg.me, sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, martin.petersen@oracle.com, hare@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, Sreekanth.Reddy@broadcom.com, chaitra.basappa@broadcom.com, dledford@redhat.com

>>>>> "James" == James Bottomley <jejb@linux.vnet.ibm.com> writes:

James> Now that I look at the reviews, each of the reviewers said what
James> the correct thing to do was: return SAM_STAT_BUSY if SATL
James> commands are outstanding like the spec says.  You all get
James> negative brownie points for not insisting on a rework.

James> Does this patch (compile tested only) fix the problems for
James> everyone?

I also like this approach better.

Broadcom folks: Please comment and test.

-- 
Martin K. Petersen	Oracle Linux Engineering
