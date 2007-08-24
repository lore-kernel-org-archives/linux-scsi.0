From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 20/30] scsi: In the Advansys driver, do not cast allocation function return values
Date: Thu, 23 Aug 2007 20:03:49 -0600
Message-ID: <20070824020349.GS9163@parisc-linux.org>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44505 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbXHXCDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Aug 2007 22:03:51 -0400
Content-Disposition: inline
In-Reply-To: <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux@connectcom.net

On Fri, Aug 24, 2007 at 02:16:12AM +0200, Jesper Juhl wrote:
> There's no reason to cast void pointers returned by the generic
> memory allocation functions.

I think I fixed all these already; please check scsi-misc.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
