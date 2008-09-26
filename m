From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before
 new_buffer_tape()
Date: Fri, 26 Sep 2008 11:13:00 +0100
Message-ID: <20080926111300.1dd34009@lxorguk.ukuu.org.uk>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48321 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbYIZKNC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 06:13:02 -0400
In-Reply-To: <20080925174948.GA14180@carmen.cs.uiuc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Tan <tammy000@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 25 Sep 2008 12:49:48 -0500
Lin Tan <tammy000@gmail.com> wrote:

> (I would wish to be personally CC'ed the answers/comments posted to the list in response to my posting.)
> 
> ---
> 
> Removing the wrong comment.
> The lock is needed before calling new_tape_buffer(), at least in some cases.
> So the comment above new_tape_buffer() is inconsistent with the code and
> may mislead developers.
> 
> I simply removed the wrong comment, as I am not sure if the lock is required
> in all situations. If so, we should add "Caller must hold os_scsi_tapes_lock".
> 
> Signed-off-by: Lin Tan <tammy000@gmail.com>

Looks true to me for the current versions of the code. In fact it is only
ever called from the initialisation function that I can see so chunks of
the code could simply go away as well as bits of the comment. Ditto the
one in drivers/scsi/st.c

Acked-by: Alan Cox <alan@redhat.com>

