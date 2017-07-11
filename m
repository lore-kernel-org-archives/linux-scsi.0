From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] iscsi-target: Reject immediate data underflow larger than
 SCSI transfer length
Date: Tue, 11 Jul 2017 16:17:05 +0000
Message-ID: <1499789824.2586.16.camel@wdc.com>
References: <1496895685-18464-1-git-send-email-nab@linux-iscsi.org>
         <1496936253.3028.1.camel@wdc.com>
         <1496991302.28997.66.camel@haakon3.risingtidesystems.com>
         <1499757761.28145.45.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:7293 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932731AbdGKQRJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 12:17:09 -0400
In-Reply-To: <1499757761.28145.45.camel@haakon3.daterainc.com>
Content-Language: en-US
Content-ID: <BF10908A7BF1A94DB9098439EAF0747E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "roland@purestorage.com" <roland@purestorage.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>

On Tue, 2017-07-11 at 00:22 -0700, Nicholas A. Bellinger wrote:
> So rejecting this case as already done in commit abb85a9b51 is the
> correct approach for >=3D v4.3.y.

Hello Nic,

I hope that you agree that the current target_cmd_size_check() implementati=
on
is complicated and ugly. Patch 30/33 of the patch series I referred to in m=
y
e-mail removes a significant number of lines of code from that function. So
my patch series not only makes target_cmd_size_check() easier to maintain a=
nd
to verify but it makes that function also faster. Hence please reconsider t=
he
approach from my patch series. For patch 30/33, see also
https://www.spinics.net/lists/target-devel/msg15384.html.

Bart.=
