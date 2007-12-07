From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [OpenFCoE PATCH] [PATCH] Performance improvement,	combine received data copy with CRC.
Date: Fri, 7 Dec 2007 09:33:03 -0800
Message-ID: <10A7D0016239E24092DEF05CCC582E43029D720B@fmsmsx411.amr.corp.intel.com>
References: <20071205005224.26269.68039.stgit@mink.he.net> <47589D5A.10501@linux.intel.com> <4758A1E6.6010903@eykholt.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbXLGRkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 12:40:22 -0500
Content-class: urn:content-classes:message
In-Reply-To: <4758A1E6.6010903@eykholt.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <fcoe@eykholt.com>, Rob Love <robert.w.love@linux.intel.com>
Cc: linux-scsi@vger.kernel.org

>Rob Love wrote:
>> Joe Eykholt wrote:
>>> [PATCH] Performance improvement, combine received data copy with
CRC.
>>>
>> Shouldn't we remove  openfc_cp_to_user() if we're moving that
>> functionality into openfc_scsi_recv_data()?
>
>Yes.  That was an oversight.  I did intend to remove it.
>Do you want a new patch for that or will you take care of it?
>
I can take care of it.
