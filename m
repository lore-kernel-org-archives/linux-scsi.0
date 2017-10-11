From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: add check for changing allow_restart
Date: Wed, 11 Oct 2017 13:22:18 -0400
Message-ID: <yq1d15tha5x.fsf@oracle.com>
References: <20170927165313.GA36250@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24827 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdJKRWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 13:22:31 -0400
In-Reply-To: <20170927165313.GA36250@localhost.didichuxing.com> (weiping
        zhang's message of "Thu, 28 Sep 2017 00:53:18 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org


weiping,

> /sys/class/scsi_disk/0:2:0:0/allow_restart can be changed to 0 unexpectly by
> writing invalid string, like following:
>
> echo asdf > /sys/class/scsi_disk/0:2:0:0/allow_restart

Please switch to kstrtobool() and fix up manage_start_stop as well.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
