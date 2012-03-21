From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 05/17] be2iscsi:Fix typo function name mismatch
Date: Wed, 21 Mar 2012 18:57:18 -0500
Message-ID: <4F6A6ADE.8080203@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu> <1332294488-13684-6-git-send-email-michaelc@cs.wisc.edu> <5978796.vmDf5npbmM@eto>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35049 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2CUX6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2012 19:58:17 -0400
In-Reply-To: <5978796.vmDf5npbmM@eto>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <MinhDuc.Tran@emulex.com>

On 03/21/2012 05:21 PM, Rolf Eike Beer wrote:
> Am Dienstag 20 M=E4rz 2012, 20:47:56 schrieb michaelc@cs.wisc.edu:
>> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>>
>> Signed-off-by: Minh Tran <MinhDuc.Tran@Emulex.Com>
>> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>  drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c
>> b/drivers/scsi/be2iscsi/be_iscsi.c index 33c8f09..2bb681e 100644
>> --- a/drivers/scsi/be2iscsi/be_iscsi.c
>> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
>> @@ -221,7 +221,7 @@ int beiscsi_ep_get_param(struct iscsi_endpoint *=
ep,
>>  	struct beiscsi_endpoint *beiscsi_ep =3D ep->dd_data;
>>  	int len =3D 0;
>>
>> -	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_param, param=3D %d\n", pa=
ram);
>> +	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_get_param, param=3D %d\n", para=
m);
>>
>>  	switch (param) {
>>  	case ISCSI_PARAM_CONN_PORT:
>=20
> What about:
>=20
> SE_DEBUG(DBG_LVL_8, "In %s, param=3D %d\n", __func__, param);
>=20

Right now the rest of the driver does it the way in the patch, so that
is why I kept the current style. In another patch I was going to go
through the driver and modify the SE_DEBUG DBG_LEVEL stuff so that it
did what you suggest for all functions. The patchset was getting large
so I wanted to get the fix done, then do the major change that modifies
all logging in another patch in the next set.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
