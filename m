From: Liran Schour <LIRANS@il.ibm.com>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 13:46:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF1494DF8F.2FB4A44D-ONC2256DE2.004036A3-C2256DE2.0040B333@il.ibm.com>
References: <20031118113148.A23709@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:9454 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP id S262129AbTKRLw5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 06:52:57 -0500
In-Reply-To: <20031118113148.A23709@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org





Christoph Hellwig wrote:

> You'd have to enlarge MAX_COMMAND_SIZE, that'S the whole point of it :)
> What exactly are you trying to do and for what kernel release?  We've
> been through increasing it from 12 to 16 at some point in 2.4.

I am trying to find a way to do that without the need to recompile the
kernel.
I am trying to support an OSD device see t10 OSD draft, I think that 2.6 is
my target kernel release.

Thanks,
- Liran



