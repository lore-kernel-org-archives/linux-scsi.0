From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] alua: clarify messages when blk_execute_rq fails
Date: Tue, 30 Aug 2011 14:37:28 -0700
Message-ID: <1314740248.7613.1.camel@dabdike.conference.net>
References: <1313182877-31377-1-git-send-email-revers@redhat.com>
	 <4E5D4318.6010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38890 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab1H3Vhg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 17:37:36 -0400
In-Reply-To: <4E5D4318.6010809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-08-30 at 16:07 -0400, Rob Evers wrote:
> On 08/12/2011 05:01 PM, Rob Evers wrote:
> > replace numeric messages with string error messages when blk_execute_rq
> > fails.  Also add printing of sense info.
> >
> > Mike Christie suggested adding printing of sense info here
> >
> > Signed-off-by: Rob Evers<revers@redhat.com>
> >
> 
> Hi James,
> 
> Do you have any feedback on these patches?
> 
> (I already noticed the 2nd patch is a reply to the first)
> 
> I didn't see them in the last update of scsi-misc.

I don't really see any point in removing messages.  If Hannes is OK with
the ALUA sense one, he'll send it to me.

James



