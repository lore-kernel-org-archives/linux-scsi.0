From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH/RFC] Allowing REQ_FAILFAST to be set from SG_IO
Date: Thu, 11 May 2006 12:28:14 +0200
Message-ID: <446311BE.8070104@suse.de>
References: <4461EFD0.50902@suse.de> <446217D5.3020606@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:21701 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750738AbWEKK23 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 06:28:29 -0400
In-Reply-To: <446217D5.3020606@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Hannes Reinecke wrote:
>> Hi all,
>>
>> this patch allows to set the REQ_FAILFAST flag to be set from SG_IO
>> commands. With it one can send generic SCSI commands which behave
>> exactly like normal requests send via the block layer.
>>
>> Comments etc welcome.
>=20
> Hannes,
> Looks good. There is no proposed change to sg.c .
> Could SG_FLAG_FAILFAST be made to work via sg device
> nodes?
>=20
That will be tricky. sg.c is using scsi_execute_async() which doesn't
provide for any flags to be passed.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
