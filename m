From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] modify the type of element of MessageUnit_B in arcmsr
Date: Thu, 06 Mar 2008 16:28:35 -0600
Message-ID: <1204842515.3062.79.camel@localhost.localdomain>
References: <000601c87f2e$71731610$8800a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42359 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586AbYCFW2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:28:40 -0500
In-Reply-To: <000601c87f2e$71731610$8800a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk

On Thu, 2008-03-06 at 10:04 +0800, nickcheng wrote:
> James,
> You are such a great teacher. 

Heh, you know how to smooth talk

> I learned it.
> So what about my last submitted patch?
> Would it be turned down or go on?

I'm fine with either fix.  For either we need a better changelog.

Something like:

The Type B Adapter teardown does iounmap on pointers subtracted by a
constant offset.  Since the offset is in bytes, we need the pointers to
be of type void * not uint32_t * so the subtraction is done in the
correct units and we iounmap the correct area.

Signed-off-by: ...

James


