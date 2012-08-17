From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
Date: Fri, 17 Aug 2012 12:11:50 -0400
Message-ID: <yq1d32ph515.fsf@sermon.lab.mkp.net>
References: <1345127925-32042-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51727 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2HQQL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Aug 2012 12:11:59 -0400
In-Reply-To: <1345127925-32042-1-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Thu, 16 Aug 2012 16:38:45 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, tytso@mit.edu, pbonzini@redhat.com, linux-kernel@vger.kernel.org

>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:

Lukas> Currently it is possible to unmap one more block than user
Lukas> requested to due to the off-by-one error in unmap_region(). This
Lukas> is probably due to the fact that the end variable despite its
Lukas> name actually points to the last block to unmap + 1. However in
Lukas> the condition it is handled as the last block of the region to
Lukas> unmap.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
