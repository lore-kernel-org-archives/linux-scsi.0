From: Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [PATCH] remove dead cyrix/centaur mtrr init code
Date: Mon, 28 Feb 2005 22:51:36 +0100
Message-ID: <20050228215136.GB15612@apps.cwi.nl>
References: <20050228192001.GA14221@apps.cwi.nl> <20050228193529.GG4021@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from hera.cwi.nl ([192.16.191.8]:32198 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261770AbVB1V7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 16:59:10 -0500
Content-Disposition: inline
In-Reply-To: <20050228193529.GG4021@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Feb 28, 2005 at 08:35:29PM +0100, Adrian Bunk wrote:
> Hi Andries,
> 
> your patch has many overlappings with a patch of mine aleady in -mm 
> (both none of the two patches is a subset of the other one).
> 
> Nowadays, working against -mm often avoids duplicate work.
> 
> cu
> Adrian

As far as I am concerned this doesnt matter so much.

This is very trivial work, and only little time is wasted
in case of duplication. It is unavoidable.

(For example, looking at the detect functions of scsi drivers
I happened to come across pas16.c and did a largish cleanup.
Hesitate a bit submitting the results, since the driver showed
some signs of bitrot - maybe nobody has used it for years -
if someone uses pas16, please tell me - let me cc linux-scsi -
but today you submit a little patch on pas16.)

Andries
