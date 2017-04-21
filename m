From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Fri, 21 Apr 2017 22:20:55 +0000
Message-ID: <517934B3-AB1F-459E-95F4-1F77AC3E6302@fb.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
 <1492809452.2499.2.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59847 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1162365AbdDUWVh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 18:21:37 -0400
In-Reply-To: <1492809452.2499.2.camel@sandisk.com>
Content-Language: en-US
Content-ID: <C4A3BBC515E8D040BAB3B495C10ADB0B@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>


> On Apr 21, 2017, at 2:17 PM, Bart Van Assche <Bart.VanAssche@sandisk.com>=
 wrote:
>=20
> On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
>> When a device is deleted through sysfs handle "delete", [ ... ]
>=20
> If I try to use that sysfs attribute then I encounter a deadlock (see
> also the report below). How is it possible that you have not hit that
> deadlock in your tests?
>=20
> Bart.


Hmm... Seems my test environment (VM) doesn't call the following path

       __scsi_remove_device+0xe9/0x120
       scsi_forget_host+0x60/0x70
       scsi_remove_host+0x71/0x110

Let me fix it.=20

Thanks,
Song=
