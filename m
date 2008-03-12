From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] isd200: Fix memory leak in isd200_get_inquiry_data
Date: Wed, 12 Mar 2008 11:11:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803121110320.4595-100000@iolanthe.rowland.org>
References: <47D7E0D1.8050403@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754481AbYCLPLY@vger.kernel.org>
In-Reply-To: <47D7E0D1.8050403@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 12 Mar 2008, Boaz Harrosh wrote:

> rrr only I cannot do that because the destructor does not have access to the us_data
> that contains it. As I said, very ugly. New patch attached.
> 
> Boaz
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Tue, 11 Mar 2008 20:30:53 +0200
> Subject: [PATCH] isd200: Fix memory leak in isd200_get_inquiry_data
> 
> if the inquiry fails then the info structure on
> us->extra was not freed.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern
