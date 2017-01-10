From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Mon, 09 Jan 2017 23:50:56 -0500
Message-ID: <yq1eg0bcybz.fsf@oracle.com>
References: <20161229080250.GA11605@infradead.org>
        <1483226343.2518.32.camel@linux.vnet.ibm.com>
        <1483280506.5512.1.camel@sandisk.com>
        <20170101.113311.417107391370623850.davem@davemloft.net>
        <1483292364.2345.5.camel@linux.vnet.ibm.com>
        <yq1y3ypgd7m.fsf@oracle.com>
        <CAK=zhgqKxyfj2YM6r-F7A_prS8yh61j3otKk2+kTyEOEj4F=xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23978 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933132AbdAJEvr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 23:51:47 -0500
In-Reply-To: <CAK=zhgqKxyfj2YM6r-F7A_prS8yh61j3otKk2+kTyEOEj4F=xw@mail.gmail.com>
        (Sreekanth Reddy's message of "Fri, 6 Jan 2017 21:16:25 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, jbaron@akamai.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, sagi@grimberg.me, Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, dledford@redhat.com

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@broadcom.com> writes:

Sreekanth> We are fine with this patch. Can we rename function
Sreekanth> 'set_satl_pending()' name to '_scsih_set_satl_pending()' and
Sreekanth> can add headers to this function.

Sreekanth> other wise I am OK.

Sreekanth> Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

James: Please tweak and post an updated patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
