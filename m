From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: [PATCH 2.5] fix megaraid driver compile error
Date: Thu, 6 Feb 2003 12:04:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302061202430.3545-100000@home.transmeta.com>
References: <1044559247.4858.49.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1044559247.4858.49.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On 6 Feb 2003, Mark Haverkamp wrote:
>
> This moves access of the host element to device since host has been
> removed from struct scsi_cmnd.

This is whitespace-damaged.

Please fix broken mailers. I generally don't bother to fix up whitespace
damage from people who can't bother to have a good mailer. It's just not 
worth it - if I try to fix it up (even if it is often trivial), it just 
means that people will continue to send crap patches to me.

		Linus

