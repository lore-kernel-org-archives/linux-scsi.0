From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 7/7] aic79xx_core: remove ascii art
Date: Fri, 02 May 2008 16:10:32 -0500
Message-ID: <1209762632.3121.63.camel@localhost.localdomain>
References: <200805022044.m42Kiv17013977@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46409 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932685AbYEBVKg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 17:10:36 -0400
In-Reply-To: <200805022044.m42Kiv17013977@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-05-02 at 13:44 -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Those '<<<<<<<' lines keep on emitting false-positives when I'm grepping for
> git conflicts.  Replace them with '='.

I'm not opposed to this in principle, but I have to ask how?  The grep
for conflicts remaining in a file is

egrep '^<<<<<<<|^=======|^>>>>>>' <file>

Which doesn't match anything in the aic7xxx directory.  If you're
grepping without the anchor, then you're going to get another match
looking for ===== with your change, aren't you?

James


