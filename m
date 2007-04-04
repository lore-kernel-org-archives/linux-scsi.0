From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 11:55:36 -0700
Message-ID: <20070404115536.fd752555.akpm@linux-foundation.org>
References: <200704031508.37222.kern@sibbald.com>
	<20070403145728.d8f83320.akpm@linux-foundation.org>
	<150283e90704032000p7f447a26pe3752b22024a1b67@mail.gmail.com>
	<200704041626.15298.kern@sibbald.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993028AbXDDS42 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2007 14:56:28 -0400
In-Reply-To: <200704041626.15298.kern@sibbald.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kern Sibbald <kern@sibbald.com>
Cc: Willem Riede <wrlk@riede.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On Wed, 4 Apr 2007 16:26:14 +0200 Kern Sibbald <kern@sibbald.com> wrote:

>  I'm all in favor of deprecating ide-tape if ide-scsi is a viable alternative, 

ow.  ide-scsi is in very bad shape and nobody is maintaining it or fixing
bugs in it or anything.  The only reason we retain ide-scsi at all is, err,
because some tape drives need it.

If we have no alternative to using ide-scsi, and if the tape controllers in
question are not some terribly obscure things which nobody would seriously
use then we have a bit of a problem.  I don't know of anyone who we can
turn to to get anything done in ide-scsi.


