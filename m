From: John Levon <levon@movementarian.org>
Subject: Re: [PATCH] kill two scsi ioctls
Date: Thu, 10 Apr 2003 17:38:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030410163828.GC93213@compsoc.man.ac.uk>
References: <UTC200304101633.h3AGXQ125592.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serenity.mcc.ac.uk ([130.88.200.93]:34319 "EHLO
	serenity.mcc.ac.uk") by vger.kernel.org with ESMTP id S264097AbTDJQ0w (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 12:26:52 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304101633.h3AGXQ125592.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 10, 2003 at 06:33:26PM +0200, Andries.Brouwer@cwi.nl wrote:

> The definition for SCSI_IOCTL_BENCHMARK_COMMAND was added in 1.1.2.
> The definition for SCSI_IOCTL_SYNC was added in 1.1.38.
> Neither of them has ever been used.

Can't you at least add a comment about what was there ? It's quite
annoying to come across :

#define FOO 1
#define BAR 2
#define BAZ 5

and have no idea why

regards
john
