From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] fix read capacity for large disks when CONFIG_LBD=n(updated)
Date: Tue, 4 Jan 2005 12:56:25 -0500
Message-ID: <05Jan4.125626est.332664@cyborg.cybernetics.com>
References: <1104860756.5327.50.camel@mulgrave>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:23816 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261735AbVADSAd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 13:00:33 -0500
In-Reply-To: <1104860756.5327.50.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

> Actually, I don't think this is at all a good idea.  Not 
> allowing a LBD
> device to be configured if the user hasn't enabled LBD (which is
> accidentally what the current code does) seems better to me.

That's fine with me.

Anthony J. Battersby
Cybernetics

