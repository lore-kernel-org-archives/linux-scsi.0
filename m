From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Mon, 13 Jan 2014 18:33:39 +0200
Message-ID: <52D41563.9050309@dev.mellanox.co.il>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-8-git-send-email-nab@daterainc.com>	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>	<52D286D9.5050500@dev.mellanox.co.il> <52D2C4C2.2040800@interlog.com> <yq1ppnxnmj4.fsf@sermon.lab.mkp.net> <52D2E4A9.7010004@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:52375 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaAMQdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2014 11:33:45 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so3420642eaj.15
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2014 08:33:44 -0800 (PST)
In-Reply-To: <52D2E4A9.7010004@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>


> Back to the original question, I don't think Sagi was
> asking if it was valid to do a legacy/unprotected READ,
> it was what to expect with a protected READ on
> unwritten blocks:
>
> > So this takes me to a corner I still don't understand, if
> > a LUN is pre-formatted as T10-protected, what happens to
> > unwritten blocks read?
>
> So the precise answer is: the PI will be all 0xff bytes,
> unless logical provisioning is enabled, LBPRZ=0 and the
> device's compliance predates sbc3r34.pdf (November 2012).
>
> Doug Gilbert
>
>

Thanks Doug,

This answer translates directly into a fix in my T10-PI offload API.

Sagi.
