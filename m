From: James Morris <jmorris@redhat.com>
Subject: Re: [PATCH] Add CRC32C chksums to crypto routines
Date: Mon, 19 Jan 2004 15:13:15 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Xine.LNX.4.44.0401191512140.1564-100000@thoron.boston.redhat.com>
References: <yqujisje43q9.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57018 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262730AbUASUNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 15:13:22 -0500
In-Reply-To: <yqujisje43q9.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>

On Wed, 14 Jan 2004, Clay Haapala wrote:

> This patch against 2.6.1 adds CRC32C checksumming capabilities to the
> crypto routines.  The structure of it is based wholly on the existing
> digest (md5) routines, the main difference being that chksums are
> often used in an "accumulator" fashion, effectively requiring one to
> set the seed, and the digest algorithms don't do that.

Looks good to me.


- James
-- 
James Morris
<jmorris@redhat.com>


