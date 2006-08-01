From: "Scott Lowrey" <slowrey@nextone.com>
Subject: RE: Fusion MPT Modules for Linux 2.6.11 and LSI Logic 53c1030?
Date: Tue, 1 Aug 2006 10:38:46 -0400
Message-ID: <8812D8156467224C9E9739E513037EF101297C8B@moe.nextone.local>
References: <44CA3805.3020307@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.nextone.com ([209.125.86.105]:17567 "EHLO
	mail2.nextone.com") by vger.kernel.org with ESMTP id S1750775AbWHAOit convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Aug 2006 10:38:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <44CA3805.3020307@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Warren Volz <wvolz@lsil.com>
Cc: linux-scsi@vger.kernel.org

> On 7/24/2006 7:42 AM, Scott Lowrey wrote:
> > Is there a "correct" version of the MPT Fusion modules we should be
> > using with our kernel?
> 
> Scott,
> 
> My advice would be to use the latest driver you can get your hands on.
> Our website usually has the latest that's been released although it
can
> be hard to navigate at times... It looks like the latest released
driver
> is 3.02.68 (works for both SAS and SCSI parts). You can get this by
> going to the downloads section, and selecting the "SAS3442X" part.
> 
> -Warren

Thanks, Warren.  We've updated to 3.02.60 and so far things appear to be
working.

You're right, the Downloads page is confusing.  There are two SAS
selections (neither of which is 3442X) and they lead to pages with no
matching results.  If I simply select "LSI53C1030" from the Specific
Product menu, I get a page that offers 3.02.52 for SuSE 9.1.   There are
no SAS products in the Specific Product menu.

Am I looking in the wrong place?

-Scott
