From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 12/15] lpfc: Fix rport leak.
Date: Tue, 26 May 2015 07:31:37 -0700
Message-ID: <1432650697.2189.7.camel@HansenPartnership.com>
References: <555e1c10.+P+E84TfJG4E7Wsc%james.smart@avagotech.com>
	 <20150524135636.00000f81@localhost> <5564755B.5030302@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53420 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbbEZObj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2015 10:31:39 -0400
In-Reply-To: <5564755B.5030302@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org

On Tue, 2015-05-26 at 09:30 -0400, James Smart wrote:
> Sebastian,
> 
> Re: more than 1 space between a type declaration and a variable name - I 
> do not believe that's a hard requirement. It fully passes checkpatch. 
> Yes, consistent style use (aligning all variable names at same offset, 
> or always 1) would be good - but code has been there so long with 
> althernate styles it doesn't really matter at this point.  I did clean 
> up those in your last review as I needed to do a mod for the LS_RJT 
> behavior. But... this seems like a nit.   I did promise Christoph that I 
> would pick a good point and retrofit the sources for all sparse warnings 
> - and still owe him.

Checkpatch is a guideline rather than absolute.  It picks up a lot of
useful stuff, but also whines about a lot of irrelevant things.  In
general, errors have to be fixed but a lot of warnings are ignorable
(some warnings, like space instead of tabs aren't, but a lot are).  In
the case of warnings, it's up to the maintainer to judge if they match
the current style of the driver.

> Re: Checkpatch and string splitting. I understand we aren't passing 
> checkpatch for that rule, but joining them would have checkpatch 
> flagging us for beyond 80 character lines. I'd much rather have the 
> splits and keep the indenting for readability. We have also had this 
> error quite a bit in the past and believe we have been grandfathered as 
> there's a lot of this already.

I consider the line over 80 characters one of the most bogus checkpatch
warnings, so I would prefer not splitting strings, but it's only a
warning, so well within the bounds of the maintainer to decide based on
the internal style of the driver.

James

> James B - any comments on the above ?



