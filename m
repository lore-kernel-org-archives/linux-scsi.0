From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH resend] scsi: fc: drop residual tsk_mgmt_response and
 it_nexus_response
Date: Wed, 21 Jun 2017 18:34:33 +0000
Message-ID: <1498070072.2746.19.camel@wdc.com>
References: <1498013310-29253-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:57427 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdFUSeg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2017 14:34:36 -0400
In-Reply-To: <1498013310-29253-1-git-send-email-wangkefeng.wang@huawei.com>
Content-Language: en-US
Content-ID: <5EB972BADC43F54D8D28E6260778D5ED@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>

On Wed, 2017-06-21 at 10:48 +0800, Kefeng Wang wrote:
> After commit 556e26a70b64 ("scsi: remove tsk_mgmt_response and
> it_nexus_response transport methods"), the target driver support
> was removed totally. Drop the residua.

Hello Kefeng,

Did you mean "residual" instead of "residua"? Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
