From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/9] sd: Remove white space before EOL
Date: Fri, 21 Apr 2017 17:22:30 +0000
Message-ID: <1492795349.2550.17.camel@sandisk.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
         <20170421091649.25287-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:51977 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041227AbdDUS2e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 14:28:34 -0400
In-Reply-To: <20170421091649.25287-2-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <BAA6E147020EFD46B105BC37059B9C7C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
> No functional change is introduced by this patch.

Hello Damien,

The only tree for which I know that this kind of whitespace / coding style
patches are welcome is the staging tree. In general such patches are not
considered welcome because:
- Such patches pollute the changelog and make it harder to use tools like
  git annotate / git blame.
- Such patches make it harder for distro maintainers to backport patches
  from upstream kernels to distro (enterprise) kernels.
- If any kernel developer has developed kernel patches for the sd driver
  against kernel v4.11 and wants to submit these after the v4.12 merge
  window then that developer will have to rebase (and retest) these
  patches on top of kernel v4.12-rc1. Whitespace patches trigger really
  ugly rebase conflicts and hence are painful for other kernel developers.

Hence my request to drop this patch.

Thanks,

Bart.=
