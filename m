From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] hpsa: move lockup_detected attribute to host attr
Date: Mon, 09 Nov 2015 12:46:46 -0500
Message-ID: <yq137wfxdyx.fsf@sermon.lab.mkp.net>
References: <1446823449-3986-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47594 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbKIRqx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 12:46:53 -0500
In-Reply-To: <1446823449-3986-1-git-send-email-thenzl@redhat.com> (Tomas
	Henzl's message of "Fri, 6 Nov 2015 16:24:09 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, don.brace@pmcs.com

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> This patch fixes a 'general protection fault' issue by moving the
Tomas> attribute to where it was likely meant.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
