From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Kernel panic when re-inserting Adaptec PCMCIA card
Date: Sun, 2 Jul 2006 20:48:42 +0200
Message-ID: <20060702184842.GA18192@dominikbrodowski.de>
References: <20060614022139.21737.qmail@web50208.mail.yahoo.com> <20060615162912.744328ad.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.239.214.66]:40324 "EHLO linta.de")
	by vger.kernel.org with ESMTP id S932780AbWGBTJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2006 15:09:10 -0400
Content-Disposition: inline
In-Reply-To: <20060615162912.744328ad.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Alex Davis <alex14641@yahoo.com>, linux-scsi@vger.kernel.org, linux-pcmcia@lists.infradead.org

Hi,

On Thu, Jun 15, 2006 at 04:29:12PM -0700, Randy.Dunlap wrote:
> It gets even worse for me.  Card ejection does not cause
> aha152x_detach() to be called. but I don't see why not.
> Dominik, can you give me a clue here, please?

Is aha152x bound to it in between? Also, does its ->probe() function return
zero or not?

	Dominik
