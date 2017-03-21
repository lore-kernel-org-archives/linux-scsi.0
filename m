From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 13:30:45 +0000
Message-ID: <1490103027.2602.5.camel@sandisk.com>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
         <1490101519.2412.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:55607 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756870AbdCUNax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2017 09:30:53 -0400
In-Reply-To: <1490101519.2412.13.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <8EF6C21875B16648AAECE416D2C98C61@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hck@suse.de" <hck@suse.de>, "hare@suse.com" <hare@suse.com>

On Tue, 2017-03-21 at 09:05 -0400, James Bottomley wrote:
> How does this preserve ordering?  It looks like you have one cookie per
> sdkp ... is there some sort of ordering guarantee I'm not seeing?

Hello James,

Since the probe order depends on the order in which __async_probe() adds
entries to the "pending" list, and since the order of the __async_probe()
calls is not changed by this patch, shouldn't the probe order be preserved
by this patch?

Thanks,

Bart.=
