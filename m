From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 7/7] aic79xx_core: remove ascii art
Date: Sat, 03 May 2008 01:00:49 -0400
Message-ID: <481BF181.20005@garzik.org>
References: <200805022044.m42Kiv17013977@imap1.linux-foundation.org>	<1209762632.3121.63.camel@localhost.localdomain> <20080502141641.99fd8c65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33745 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYECFAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 May 2008 01:00:54 -0400
In-Reply-To: <20080502141641.99fd8c65.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Fri, 02 May 2008 16:10:32 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
>> On Fri, 2008-05-02 at 13:44 -0700, akpm@linux-foundation.org wrote:
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>>
>>> Those '<<<<<<<' lines keep on emitting false-positives when I'm grepping for
>>> git conflicts.  Replace them with '='.
>> I'm not opposed to this in principle, but I have to ask how?  The grep
>> for conflicts remaining in a file is
>>
>> egrep '^<<<<<<<|^=======|^>>>>>>' <file>
>>
>> Which doesn't match anything in the aic7xxx directory.  If you're
>> grepping without the anchor, then you're going to get another match
>> looking for ===== with your change, aren't you?
> 
> Yeah, I'm being lazy.  Might as well drop it and I'll do more typing :)

Bah, I agree with the patch, let's put it in.

I always look for '<<<<' too.

	Jeff



