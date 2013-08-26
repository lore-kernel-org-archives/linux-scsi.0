From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [TRIVIAL PATCH 0/2] Fix warnings in kernel build
Date: Mon, 26 Aug 2013 21:53:05 +0400
Message-ID: <1377539585.7961.5.camel@dabdike>
References: <1377536800-2298-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33629 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab3HZRxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 13:53:19 -0400
In-Reply-To: <1377536800-2298-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2013-08-26 at 13:06 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> The patch to add uevents for certain Unit Attention codes
> had a couple of problems which were found by a kbuild test robot.
> Sorry about that, I will be more careful next time.

I already did both of these based on Fengguang's checker results ...

James


