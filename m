From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag
Date: Thu, 15 Jan 2015 15:26:15 -0800
Message-ID: <1421364375.2076.6.camel@HansenPartnership.com>
References: <5c5aa6a1-3ab9-4f4b-88c6-3ffe4dd0c342@CMEXHTCAS2.ad.emulex.com>
	 <54B84A53.3030300@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38661 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbbAOX0R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2015 18:26:17 -0500
In-Reply-To: <54B84A53.3030300@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>

On Thu, 2015-01-15 at 17:16 -0600, Mike Christie wrote:
> On 01/12/2015 05:05 PM, Minh Duc Tran wrote:
> > 
> >> From: Minh Duc Tran 
> >> Sent: Sunday, November 09, 2014 10:52 PM
> >> To: 'linux-scsi@vger.kernel.org'
> >> Cc: Mike Christie (michaelc@cs.wisc.edu); Jayamohan Kallickal
> >> Subject: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag
> > 
> >> From: Minh Tran minhduc.tran@emulex.com
> > 
> >>               We are starting to see problems with certain open-iscsi versions out there checking block valid bit.  Iscsi boot target login will not happen without this bit being set.
> > 
> >> Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
> >> ---
> >> scsi/be2iscsi/be_main.c |    4 ++--
> >> 1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> >> diff --git a/scsi/be2iscsi/be_main.c b/scsi/be2iscsi/be_main.c
> >> index 30d74a0..aacf223 100644
> >> --- a/scsi/be2iscsi/be_main.c
> >> +++ b/scsi/be2iscsi/be_main.c
> >> @@ -429,7 +429,7 @@ static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
> >>                             auth_data.chap.intr_secret);
> >>                break;
> >>        case ISCSI_BOOT_TGT_FLAGS:
> >> -               rc = sprintf(str, "2\n");
> >> +               rc = sprintf(str, "3\n");
> >>                break;
> >>        case ISCSI_BOOT_TGT_NIC_ASSOC:
> >>                rc = sprintf(str, "0\n");
> >> @@ -466,7 +466,7 @@ static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)
> > 
> >>        switch (type) {
> >>        case ISCSI_BOOT_ETH_FLAGS:
> >> -               rc = sprintf(str, "2\n");
> >> +               rc = sprintf(str, "3\n");
> >>                break;
> >>        case ISCSI_BOOT_ETH_INDEX:
> >>                rc = sprintf(str, "0\n");
> >> --
> >> 1.7.1
> > 
> > Hi Mike,
> > I think we have lost track of this patch.  I've checked 3.19-rc3 today and it's not in yet.  Can we get this in as soon as possible?
> > 
> 
> The thread got a little busted in my mailer, so I might have missed
> something.

What seems to have happened is that the reply before this erased all the
References: headers and didn't set an In-reply-to: header.

Minh, this is fairly standard RFC non-compliance from Microsoft email
clients.  Since you're posting from a Mac, could you just use the native
apple email clients, because they preserve threading?

Alternatively, there's a hotfix for the issue if you can get your IT
department to apply it:

http://support.microsoft.com/kb/908027/en-us

Thanks,

James


