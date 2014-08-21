From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support
Date: Thu, 21 Aug 2014 17:47:39 -0400
Message-ID: <yq17g21qzus.fsf@sermon.lab.mkp.net>
References: <1407364668-20931-1-git-send-email-anish@chelsio.com>
	<1407364668-20931-2-git-send-email-anish@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37175 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaHUVsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 17:48:52 -0400
In-Reply-To: <1407364668-20931-2-git-send-email-anish@chelsio.com> (Anish
	Bhatt's message of "Wed, 6 Aug 2014 15:37:48 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com

>>>>> "Anish" == Anish Bhatt <anish@chelsio.com> writes:

Anish,

Just a heads up that we've got some changes due to land shortly that'll
provide interfaces for you to get the correct transfer lengths, size of
the protection interval, etc. Your patch should be rebased on top of
those changes.

-- 
Martin K. Petersen	Oracle Linux Engineering
