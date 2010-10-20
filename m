From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 3/6] bfa: remove os wrapper functions and macros
Date: Wed, 20 Oct 2010 16:16:09 -0700
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CF813105@HQ1-EXCH01.corp.brocade.com>
References: <1287447149-28678-1-git-send-email-huangj@brocade.com>
 <4CBF09DF.8000308@redhat.com> <4CBF6A38.7060502@cs.wisc.edu>
 <4CBF7569.90708@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:42035 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab0JTXRD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 19:17:03 -0400
In-Reply-To: <4CBF7569.90708@cisco.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>It's in <scsi/fc_frame.h> as hton24() / ntoh24().  It's written in
>an endian-independent way.   I don't know of patches to move them to
>a better place.
>
>	Joe

Yes I noticed these two functions for this round of cleanup, but they cannot be used directly
to replace the macros we are currently using in bfa driver without changing the parameters passed in.

Thanks
Jing
