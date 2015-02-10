From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] IB/srp: Add 64-bit LUN support
Date: Tue, 10 Feb 2015 12:41:22 +0100
Message-ID: <54D9EE62.1010304@sandisk.com>
References: <54CFB228.4070208@sandisk.com>
 <1423556633.32606.7.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0090.outbound.protection.outlook.com ([207.46.100.90]:10176
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752736AbbBJLla (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2015 06:41:30 -0500
In-Reply-To: <1423556633.32606.7.camel@opteya.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

Hello Yann,

On 02/10/15 11:13, Yann Droneaud wrote:
> Le lundi 02 f=C3=A9vrier 2015 =C3=A0 18:21 +0100, Bart Van Assche a =C3=
=A9crit :
>> The largest LUN number that has been tested is 0xd2003fff00000000.
>>
>> Checked the following structure sizes with gdb:
>> * sizeof(struct srp_cmd) =3D 48
>> * sizeof(struct srp_tsk_mgmt) =3D 48
>> * sizeof(struct srp_aer_req) =3D 36
>=20
> You can use 'pahole' tool to retrieve the size (and layout) of any
> data structure from a .o object file.

Thanks, I will have a look at that tool.

>> The ibmvscsi changes have been compile tested only (on a PPC system)=
=2E
>=20
> The changelog lack of any information about the purpose of 64bit LUNs=
=2E
> Please detail a bit why and how.

You might have missed Hannes' patch series through which 64-bit LUN
support was added in the SCSI core and in most SCSI LLD drivers. The
description of one of the patches in that series reads as follows:

   "The SCSI standard defines 64-bit values for LUNs, and large arrays
    employing large or hierarchical LUN numbers become more and more
    common.

    So update the linux SCSI stack to use 64-bit LUN numbers."

Is it OK for you if I resend this patch with that text added in the
patch description ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
