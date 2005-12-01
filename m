From: James.Smart@Emulex.Com
Subject: RE: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Thu, 1 Dec 2005 10:37:35 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B84@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42467 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932266AbVLAPiC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 10:38:02 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org

> > Yes, we will sign up for this. However, we have several items on our
> > plate so we won't be on this quickly. I would hope there would be no
> > issue with accepting the patch as is and backing out the 
> relatived code
> > as part of the eventual patch.
> 
> No.  As you might have noticed fixing mid-layer bugs in 
> drivers is generally
> not okay.

Bug ?  I thought this was a feature.....  :)

I think it's a little silly to use the strong-arm tactics on this kind of
patch. I've already committed to fix it. All it does is lessen -rc testing
on the driver changes, especially if it holds up the whole group of patches
which includes things (and bug fixes) that are unrelated.

Given your response, you deem this high priority. So, I'll get on the fix
and try to get it done in time to make 2.6.15.

-- james
