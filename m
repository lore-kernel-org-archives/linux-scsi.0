From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Fri, 27 Aug 2004 08:46:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040827084605.40eebd63.rddunlap@osdl.org>
References: <412EF74A.1070106@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:38366 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266273AbUH0PsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 11:48:21 -0400
In-Reply-To: <412EF74A.1070106@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Fri, 27 Aug 2004 18:56:42 +1000 Douglas Gilbert wrote:

| After the comments on the RFC for this thread, here is
| a patch against lk 2.6.9-rc1 to kick around.
| 

A few more style comments to go along with Christoph's comments.

a.  Linux long comment style begins with "/*" on a line by itself.

b.  sizeof xyz:  style is usually sizeof(xyz)

[I find 440 of:		sizeof xyz
	2106 of:	sizeof (xyz)
	26948 of:	sizeof(xyz)
in 2.6.8.1]

c.  +		    (! scsi_sense_is_deferred(&sshd))) {

Drop the space after '!'  [from someone who loves to use spaces :]


--
~Randy
