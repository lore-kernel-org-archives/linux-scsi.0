From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [RFC/PATCH] add PCI id for HighPoint RocketRAID 2720 to mvsas
Date: Thu, 28 Oct 2010 22:24:47 -0400
Message-ID: <20101029022447.GL23388@kvack.org>
References: <20101020223110.GT2315@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:57404 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab0J2CYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 22:24:48 -0400
Content-Disposition: inline
In-Reply-To: <20101020223110.GT2315@kvack.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,

On Wed, Oct 20, 2010 at 06:31:10PM -0400, Benjamin LaHaise wrote:
> I recently built a system using the HighPoint 2720 SAS controller, which 
> is based on the Marvell 88SE9485.  In my limited testing (read: it boots), 
> the following patch is needed to get mvsas to recognize the board.  With 
> this patch, the system boots without issue and SATA passthrough seems to 
> work.  Note that I have not tested the board with any SAS drives, as I 
> only have SATA drives at present.  Any thoughts/comments on if anything 
> further is needed for this board?

No luck with this.  Under testing it eventually starts reporting bad 
sectors on writes.  Does anyone have any pointers for docs on the mvsas 
chips that I could use for debugging this?  For that matter, am I using 
the right description for the 88SE9485?

		-ben
