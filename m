From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 2/4] bfa:Fix for crash when bfa_itnim is NULL
Date: Tue, 28 Apr 2015 16:28:08 +0200
Message-ID: <553F98F8.70502@redhat.com>
References: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com> <1422953103-5470-3-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030271AbbD1O2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2015 10:28:12 -0400
In-Reply-To: <1422953103-5470-3-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com, James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org

Anil, 
the issue you are fixing here is described in comments, but adding
the description to the body of your mail might make it more attractive
for reviewers.
Please add a proper description to your patches in the future.

> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
>
>     Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
>     Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


