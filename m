From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] OOPS due to clearing eh_action prior to aborting eh
	command
Date: Wed, 07 Dec 2005 17:06:44 -0500
Message-ID: <1133993204.3303.46.camel@mulgrave>
References: <43975A8C.2030208@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24289 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030366AbVLGWGu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Dec 2005 17:06:50 -0500
In-Reply-To: <43975A8C.2030208@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James.Smart@Emulex.Com, Jeremy Higdon <jeremy@sgi.com>

On Wed, 2005-12-07 at 15:56 -0600, Michael Reed wrote:
> During my testing of fc transport attributes for the mpt fusion
> driver, I came upon this OOPS.  (Actually, I've come upon it
> too many times.  :(  )
> 
> Attached is a patch which addresses the issue.  Please give it a look.

Isn't a better patch simply to copy the eh_action and check it for null
before completing it?  That will close the done after timeout race.

James


