From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 19:34:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609193453.A19102@infradead.org>
References: <20030609162056.GA1857@lst.de> <20030609113247.B5618@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:39949 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263542AbTFISVQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:21:16 -0400
Content-Disposition: inline
In-Reply-To: <20030609113247.B5618@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Mon, Jun 09, 2003 at 11:32:47AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 11:32:47AM -0700, Matthew Dharm wrote:
> Could you please not kill all these fields?  If you want to remove command,
> go ahead, but leave the others.

No, this is intentional.  C99 initializers exist for a reason and
once of them is to keep people away from fields they don't care about.

