From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/5] target: Skip non hex characters for EVPD=0x83 NAA
 IEEE Registered Extended
Date: Fri, 16 Sep 2011 12:38:14 -0700
Message-ID: <1316201894.12820.379.camel@haakon2.linux-iscsi.org>
References: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
	 <1316169506-4441-5-git-send-email-nab@linux-iscsi.org>
	 <4E73562D.9060205@zoner.cz>  <4E735B05.4000307@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55927 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab1IPTiR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 15:38:17 -0400
In-Reply-To: <4E735B05.4000307@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Martin Svec <martin.svec@zoner.cz>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <jbottomley@parallels.com>

On Fri, 2011-09-16 at 10:19 -0400, Douglas Gilbert wrote:
> A documentation note: it should be "VPD=0x83" not "EVPD=0x83"
> in the subject line and elsewhere.
> 
> The "E" stands for "enable" and EVPD refers to a bit field in a
> INQUIRY cdb. When it is set the response should be a VPD page
> corresponding to the "page code" field in the cdb.
> 
> I made the same mistake in my tools but I hope that has all
> been cleaned up now.
> 

Ah yes, fixing this up in the commit and comments now.

Thanks Doug!

--nab


