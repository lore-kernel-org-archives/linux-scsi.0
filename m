From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 12/17] qla2xxx: Add ql2xiniexchg parameter
Date: Wed, 31 May 2017 23:29:01 +0000
Message-ID: <1496273335.2608.25.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-13-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59638 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaX37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:29:59 -0400
In-Reply-To: <20170530175432.26984-13-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <BBB2E9AF07AD9042BCA0E544962B2E75@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
> -=A0=A0=A0=A0=A0=A0=A0"For Dual Mode (qlini_mode=3Ddual), this parameter =
determines "
> -=A0=A0=A0=A0=A0=A0=A0"the percentage of exchanges/cmds FW will allocate =
resources "
> -=A0=A0=A0=A0=A0=A0=A0"for Target mode.");
> +=A0=A0=A0=A0 "For Dual Mode (qlini_mode=3Ddual), this parameter determin=
es "
> +=A0=A0=A0=A0 "the percentage of exchanges/cmds FW will allocate resource=
s "
> +=A0=A0=A0=A0 "for Target mode.");

Hello Himanshu and Quinn,

There are several pointless changes in this patch series like the above
that changes indentation from 7 spaces to five spaces. Please leave such
changes out from future patch submissions.

Thanks,

Bart.=
