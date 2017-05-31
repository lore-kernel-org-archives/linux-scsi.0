From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 15/17] qla2xxx: Accelerate SCSI BUSY status generation
 in target mode
Date: Wed, 31 May 2017 23:39:27 +0000
Message-ID: <1496273965.2608.28.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-16-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:65061 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdEaXkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:40:22 -0400
In-Reply-To: <20170530175432.26984-16-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <F2E565616443394DA8BC0B3C6FF8108A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
> +		/* FW perform Exchang validation */

Did you perhaps intend "exchange" instead of "Exchang"? Please fix this if =
you
repost this patch.

Thanks,

Bart.=
