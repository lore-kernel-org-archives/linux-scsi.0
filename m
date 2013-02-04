From: Mike <qiudayu@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/8] V2 Add support for new IBM SAS controllers
Date: Mon, 04 Feb 2013 15:00:11 +0800
Message-ID: <1359961211.2369.4.camel@localhost>
References: <20130111234346.012076652@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45053 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3BDHAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2013 02:00:22 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <qiudayu@linux.vnet.ibm.com>;
	Mon, 4 Feb 2013 16:53:33 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 5F13D2CE804A
	for <linux-scsi@vger.kernel.org>; Mon,  4 Feb 2013 18:00:16 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1470FZm50462894
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2013 18:00:15 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1470EU0010989
	for <linux-scsi@vger.kernel.org>; Mon, 4 Feb 2013 18:00:15 +1100
In-Reply-To: <20130111234346.012076652@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com

2013-01-11 17:43 -0600=EF=BC=8Cwenxiong@linux.vnet.ibm.com=EF=BC=9A
> This is version 2 of ipr patches to support new IBM SAS controllers.=20
> In V2, we have fixed the following suggestions/warning/sparse errors:
>=20
> 1.Changed simple_strtoul() to kstrtoul() in ipr_restore_iopoll_weight=
 routine.
> 2.Removed the __dev annotations.
> 3.Fixed unlock bugs which are caused by my previous patches(reported =
by sparse).
> 4.BUG_ON gcc 4.7 warning.
> 5.Fixed sparse error in original ipr driver.
>=20
> Let me know if you have any questions.
>=20
> Thanks for your help!
> Wendy

Hi Wendy

As I test with my Multiple MSI patches, where maybe some workload of
your patches.

The test results is shown by 'cat /proc/interrups':
          CPU0       CPU1       CPU2       CPU3      =20
16:     240458     261601     226310     200425   XICS Level IPI
17:          0          0          0          0   XICS Level RAS_EPOW
18:         10          0          3          2   XICS Level vc_console
19:     122182      28481      28527      28864   XICS Level ibmvscsi
20:        506    7388226        108        118   XICS Level eth0
21:          6          5          5          5   XICS Level host1-0
22:        817        814        816        813   XICS Level host1-1
LOC:     398077     316725     231882     203049  Local timer interrupt=
s
SPU:       1659        919        961        903  Spurious interrupts
CNT:          0          0          0          0  Performance
monitoring interrupts
MCE:          0          0          0          0  Machine check
exceptions

Thanks
Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
