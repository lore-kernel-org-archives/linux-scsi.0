From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect
	the	debug information during rdac_activate
Date: Fri, 28 Aug 2009 18:06:04 -0700
Message-ID: <1251507964.26079.6.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474C65F3D@cosmail01.lsi.com>
	 <1251482228.20333.9.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF474C66194@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:55953 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZH2BGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 21:06:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7T10L6G030621
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 19:00:21 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7T16293252740
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 19:06:02 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7T161Ak007266
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 19:06:02 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474C66194@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Looks good, except for this one line
> +		h->ctlr->array_name[ARRAY_LABEL_LEN-1] = '\0';

should be array_name instead.

Thanks

chandra
<snip>

