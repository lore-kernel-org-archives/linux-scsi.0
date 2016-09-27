From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch v2] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Mon, 26 Sep 2016 21:08:51 -0400
Message-ID: <yq1mviu2lp8.fsf@sermon.lab.mkp.net>
References: <20160915134456.GA30277@mwanda>
        <yq17fadz2l6.fsf@sermon.lab.mkp.net>
        <20160923112226.rteir5ivjou64ffh@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26944 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755488AbcI0BJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 21:09:41 -0400
In-Reply-To: <20160923112226.rteir5ivjou64ffh@pd.tnic> (Borislav Petkov's
        message of "Fri, 23 Sep 2016 13:22:26 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Ching Huang <ching2048@areca.com.tw>, Hannes Reinicke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, security@kernel.org

>>>>> "Borislav" == Borislav Petkov <bp@alien8.de> writes:

Borislav> Yap, Tomas said the kfree was missing on the error path but
Borislav> can we simplify this further by doing the user_len check first
Borislav> so that the kfree() is not even needed?

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
