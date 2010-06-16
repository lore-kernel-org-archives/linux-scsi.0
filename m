From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/5] Fix set but unused variable warnings
Date: Wed, 16 Jun 2010 05:09:15 -0600
Message-ID: <20100616110914.GF9298@parisc-linux.org>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com> <AANLkTikwKHITQJDaSf9BnHQ9FLiQ-KYlCWNiH438otsV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35595 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0FPLJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 07:09:16 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikwKHITQJDaSf9BnHQ9FLiQ-KYlCWNiH438otsV@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jun 16, 2010 at 03:52:58PM +1000, Julian Calaby wrote:
> Given that patches 3, 4 and 5 seem to be a cases of missing error
> handling, (3 and 4 in particular seem to be breaking things rather
> than fixing them) in my humble opinion, I think this set needs some
> work and discussion.
> 
> Justin, maybe you'd be better off posting the actual error messages
> (split up by subsystem) and letting the lists discuss them, rather
> than posting patches which are obviously wrong. (like the ones I've
> pointed out)

My first impression of patch 5 was "that can't be right", but upon review,
I concluded that was the best solution.  If we return the PTR_ERR, this
is going to confuse every user of scsi_host_alloc who are currently only
checking for NULL.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
