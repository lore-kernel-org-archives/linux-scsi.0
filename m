From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.5] fix megaraid driver compile error
Date: Thu, 6 Feb 2003 19:24:43 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206192443.A16123@infradead.org>
References: <1044559247.4858.49.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044559247.4858.49.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Thu, Feb 06, 2003 at 11:20:47AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Feb 06, 2003 at 11:20:47AM -0800, Mark Haverkamp wrote:
> This moves access of the host element to device since host has been
> removed from struct scsi_cmnd.

Any reason we can't jump straight to the v2 driver instead of fixing
the now obsolete driver?

