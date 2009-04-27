From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/6] fnic: add main file with module infrastructure,
	fnic structure, Makefile
Date: Mon, 27 Apr 2009 15:44:36 +0000
Message-ID: <1240847076.3387.20.camel@mulgrave.int.hansenpartnership.com>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>
	 <20090418013232.24787.33309.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49992 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758177AbZD0Poi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 11:44:38 -0400
In-Reply-To: <20090418013232.24787.33309.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: linux-scsi@vger.kernel.org, jeykholt@cisco.com

On Fri, 2009-04-17 at 18:32 -0700, Abhijeet Joglekar wrote:
> fnic_main.c: include module load and unload, PCI device probe, scsi-ml,
> libFC and scsi-transport-fc registration and interfaces
> 
> fnic.h: has fnic definition and other related data types
> 
> Makefile:
> 
> Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
> Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

I'm guessing this should be:

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Reviewed-by: Joe Eykholt <jeykholt@cisco.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>

?

James


