From: "Surekha.PC" <surekhap@cisco.com>
Subject: RE: [linux-iscsi-devel] [PATCH] convert cisco driver to use transport class
Date: Tue, 30 Mar 2004 19:49:09 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAq8i81Yigi0moeGE0ffHlcAEAAAAA@cisco.com>
References: <4064979F.4000800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:24581 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263661AbUC3OTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 09:19:16 -0500
In-Reply-To: <4064979F.4000800@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net


Hi Mike,

 I reviewed your patch. The changes look fine.

Thanks,
surekha

> -----Original Message-----
> From: linux-iscsi-devel-admin@lists.sourceforge.net 
> [mailto:linux-iscsi-devel-admin@lists.sourceforge.net] On 
> Behalf Of Mike Christie
> Sent: Saturday, March 27, 2004 2:21 AM
> To: SCSI Mailing List; linux-iscsi-devel@lists.sourceforge.net
> Subject: [linux-iscsi-devel] [PATCH] convert cisco driver to 
> use transport class
> 
> 
> And, here is the conversion patch.
> 
> 
>   iscsi-attr.c      |  201 
> +++++++++++++++---------------------------------------
>   iscsi-attr.h      |    2
>   iscsi-initiator.c |   72 +++++++++++--------
>   3 files changed, 97 insertions(+), 178 deletions(-)
> 
> Mike Christie
> 

