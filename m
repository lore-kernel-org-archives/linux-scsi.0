From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V5 11/11] [SCSI] aacraid: Requests at least 2 MSIx in
 pci_enable_msix_range()
Date: Mon, 17 Aug 2015 07:17:16 -0700
Message-ID: <1439821036.2211.3.camel@HansenPartnership.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <1437583757-5449-12-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <55B0E429.2090805@redhat.com>
	 <1439404140.2825.61.camel@HansenPartnership.com>
	 <B539A9786201A44A91E34268415A2B1AEC5F987E@BBYEXM02.pmc-sierra.internal>
	 <B539A9786201A44A91E34268415A2B1AEC5FAE5E@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38052 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbbHQORS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Aug 2015 10:17:18 -0400
In-Reply-To: <B539A9786201A44A91E34268415A2B1AEC5FAE5E@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

On Mon, 2015-08-17 at 14:12 +0000, Mahesh Rajashekhara wrote:
> Hi James,
> 
> Please let me know the status of V6 patchset.

Well, you altered it fairly significantly with the combination, so I
need the original reviewers at least to glance over it and say their
reviews stand.

If you kept the review tags going V5->V6, this would be a lot easier: as
long as the reviewers were cc'd, I could apply the series if they didn't
object.  Now I have to wait for them to say it's OK.

James


