From: <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 1/7] Removing the iscsi_data_pdu setting.
Date: Sun, 19 Aug 2012 16:52:27 +0000
Message-ID: <8f742053-0647-4ef1-8e64-92d7eec16efa@CMEXHTCAS1.ad.emulex.com>
References: <881ee591-57a1-4fc9-a509-fda0d864c850@exht1.ad.emulex.com>,<56D13CD3-BBFF-47F2-89AB-A12996662822@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:28483 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2HSQwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Aug 2012 12:52:32 -0400
In-Reply-To: <56D13CD3-BBFF-47F2-89AB-A12996662822@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, Sony.John-N@Emulex.Com
Cc: linux-scsi@vger.kernel.org


________________________________________
From: Michael Christie [michaelc@cs.wisc.edu]
Sent: Monday, August 13, 2012 11:41 AM
To: John, Sony
Cc: linux-scsi@vger.kernel.org; Kallickal, Jayamohan
Subject: Re: [PATCH 1/7] Removing the iscsi_data_pdu setting.

On Aug 13, 2012, at 5:29 AM, John Soni Jose <sony.john-n@emulex.com> wrote:

> The setting of iscsi_data_pdu is not required anymore,
> as this was required for BE1 adapters only.
>

>Were those released and supported by the upstream kernel in previous kernels?


The BE1 cards were never supported in any previous versions of the Kernel. So, there is no risk here

-Jay