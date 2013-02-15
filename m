From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] [SCSI] scsi_debug: Do not respond to INQUIRY commands
 with CHECK CONDITION when sense pending
Date: Fri, 15 Feb 2013 09:58:08 -0500
Message-ID: <1360940288.18372.6.camel@localhost.localdomain>
References: <1360859795-30448-1-git-send-email-emilne@redhat.com>
	 <1360859795-30448-2-git-send-email-emilne@redhat.com>
	 <511D5B4E.8020606@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422656Ab3BOO6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 09:58:12 -0500
In-Reply-To: <511D5B4E.8020606@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2013-02-14 at 16:46 -0500, Douglas Gilbert wrote:
> On 13-02-14 11:36 AM, Ewan D. Milne wrote:
> > From: "Ewan D. Milne" <emilne@redhat.com>
> >
> > According to SPC, INQUIRY commands are not supposed to respond
> > with a CHECK CONDITION due to a pending UNIT ATTENTION.  This
> > was causing failures when re-scanning a scsi_debug target.
> 
> Good pick up. Reference: sam5r12.pdf section 5.14 on
> Unit Attentions. And please add REPORT LUNS to your patch.

Will do, thanks.

-Ewan


