From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3] scsi/sd: release scan_mutex during sync_cache and
 start_stop
Date: Wed, 8 Feb 2017 23:03:35 +0000
Message-ID: <799B29A3-8991-4268-93A3-3C502AC4FC13@fb.com>
References: <20170208225353.82334-1-songliubraving@fb.com>
 <1486594677.16026.25.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37981 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751235AbdBHXDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 18:03:42 -0500
In-Reply-To: <1486594677.16026.25.camel@sandisk.com>
Content-Language: en-US
Content-ID: <E5C35C329ECC2641ADC31AD8FDA0519A@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Feb 8, 2017, at 2:58 PM, Bart Van Assche <Bart.VanAssche@sandisk.com> =
wrote:
>=20
> On Wed, 2017-02-08 at 14:53 -0800, Song Liu wrote:
>> +	try_lock_scan_mutex =3D mutex_trylock(&shost->scan_mutex);
>=20
> This is at least as bad as the approach of your previous patch because
> whether or not this mutex_trylock() call succeeds not only depends on
> whether or not the caller holds the scan_mutex but also on whether any
> other thread accidentally holds that mutex. Please stop hacking and do
> what Christoph proposed, namely address the caller of this method.
>=20
> Bart.
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality=
 Notice & Disclaimer:
>=20
> This e-mail and any files transmitted with it may contain confidential or=
 legally privileged information of WDC and/or its affiliates, and are inten=
ded solely for the use of the individual or entity to which they are addres=
sed. If you are not the intended recipient, any disclosure, copying, distri=
bution or any action taken or omitted to be taken in reliance on it, is pro=
hibited. If you have received this e-mail in error, please notify the sende=
r immediately and delete the e-mail in its entirety from your system.
>=20

Thanks for the feedback. I will dig more in the caller side.=20

Song=
