From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Date: Sat, 14 Mar 2009 15:48:20 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E02AA6C46@HQ-EXCH-5.corp.brocade.com>
References: <200903141952.n2EJqeHb028773@blc-10-6.brocade.com> <20090314211328.GC3353@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brm-mailgate-2.brocade.com ([144.49.197.3]:25726 "EHLO
	brm-mailgate-2.brocade.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbZCNXDt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 19:03:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20090314211328.GC3353@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: James.Bottomley@HansenPartnership.com, Krishna Gudipati <kgudipat@Brocade.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

> 
> Your submission was screwed up somehow?
> You had plenty of [0/5]....
> 

Yes, I forgot to increment the number so I sent them again. Sorry about
the mess.

> Have you ran this through checkpatch - and what is the result?
> Have you run this through sparse - and what is the result?
> 

We did ran checkpatch and sparse, it used to be 100% clean, but recently
we made a lot of changes to our driver, and some new issues have been
introduced, we will fix them in next submission.

Thanks for the reviewing the code!
