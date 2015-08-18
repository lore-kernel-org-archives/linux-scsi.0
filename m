From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 1/3] cxlflash: Base error recovery support
Date: Tue, 18 Aug 2015 09:41:25 -0500
Message-ID: <55D34415.8070803@linux.vnet.ibm.com>
References: <1439520454-56759-1-git-send-email-mrochs@linux.vnet.ibm.com> <55D1F1CE.1030900@linux.vnet.ibm.com> <864F3A3B-94AF-4E56-9FCA-BBD36E58FA60@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:43163 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbHROlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2015 10:41:35 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 18 Aug 2015 08:41:34 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id C382F3E40054
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 08:41:31 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7IEeXwe59179090
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 07:40:33 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7IEfTrg019400
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 08:41:31 -0600
In-Reply-To: <864F3A3B-94AF-4E56-9FCA-BBD36E58FA60@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com, mikey@neuling.org, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 08/17/2015 07:30 PM, Matthew R. Ochs wrote:
> Hi Brian,
>=20
> Thanks for reviewing.
>=20
> All good suggestions that I am fine with implementing. As these are f=
airly minor,
> would you be okay with these being made in a separate =91fix' patch s=
eries?

That's fine with me.

Thanks,

Brian

--=20
Brian King
Power Linux I/O
IBM Linux Technology Center


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
