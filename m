From: Mark Wu <wudx05@gmail.com>
Subject: Re: dangling pointers and/or reentrancy in =?utf-8?b?c2NtZF9laF9hYm9ydF9oYW5kbGVyPw==?=
Date: Wed, 21 May 2014 14:16:33 +0000 (UTC)
Message-ID: <loom.20140521T161608-391@post.gmane.org>
References: <537A105B.4080504@redhat.com> <537A1E88.9080803@acm.org> <537A2CB8.9060302@redhat.com> <537A34C6.7090905@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49727 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaEUOZE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2014 10:25:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1Wn7S2-0006wi-OX
	for linux-scsi@vger.kernel.org; Wed, 21 May 2014 16:25:02 +0200
Received: from 222.130.217.132 ([222.130.217.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 16:25:02 +0200
Received: from wudx05 by 222.130.217.132 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 16:25:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is it possible that when scsi_done is invoked, the scsi command or the 
request has been freed and then reallocated for a new I/O request?  Because 
of this the bit flag REQ_ATOM_COMPLETE becomes unreliable.  Thanks!

