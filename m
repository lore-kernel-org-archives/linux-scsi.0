From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: Fw: [Bugme-new] [Bug 3125] New: Can't read data from zip250 reiserfs partition
Date: Mon, 2 Aug 2004 22:33:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040802213323.GO12308@parcelfarce.linux.theplanet.co.uk>
References: <20040727125712.71011b65.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45979 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263865AbUHBVhB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2004 17:37:01 -0400
Content-Disposition: inline
In-Reply-To: <20040727125712.71011b65.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 27, 2004 at 12:57:12PM -0700, Andrew Morton wrote:
> 
> Looks like a repeatable crash in the imm.c driver.

Can't reproduce it here.  OTOH, randy had been able to; looks like we
might get somewhere tonight (it's on his home box).

It looks like we somehow get a SCSI command with NULL ->request_buffer
and non-zero ->request_buflen.  Which, AFAICS, should break a lot of
SCSI drivers...
