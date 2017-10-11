From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 04/10] mpt3sas: Fix removal and addition of vSES device
 during host reset
Date: Wed, 11 Oct 2017 10:19:51 -0700
Message-ID: <1507742391.3168.7.camel@HansenPartnership.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
         <1507641083-20207-5-git-send-email-Sreekanth.Reddy@broadcom.com>
         <49c623ab-899f-92c1-9c23-86ac703e2648@redhat.com>
         <1507737377.3168.4.camel@HansenPartnership.com>
         <a8d71636-b9cd-b40c-369c-d2d54416c053@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48968 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751423AbdJKRTx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Oct 2017 13:19:53 -0400
In-Reply-To: <a8d71636-b9cd-b40c-369c-d2d54416c053@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org

On Wed, 2017-10-11 at 18:12 +0200, Tomas Henzl wrote:
> On 10/11/2017 05:56 PM, James Bottomley wrote:
> > 
> > On Wed, 2017-10-11 at 17:35 +0200, Tomas Henzl wrote:
> > > 
> > > On 10/10/2017 03:11 PM, Sreekanth Reddy wrote:
> > > > 
> > > > For Dev Handles who value is less than hba's phys count number
> > > >  driver will return HBA sas address value as a sas address.
> > > > So for Virtual SES device also driver was returning HBA sas
> > > > address
> > > > instead
> > > >  of Virtual SES sas address. So now updated the driver to
> > > > return
> > > >  Virtual SES's sas address for Virtual SES device instead of
> > > >  HBA's sas address.
> > > > 
> > > > Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
> > > Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> > You mean Reviewed-by: I think?
> 
> Sure, sorry for that, corrected too late in 8/10
> should I resend with  "Reviewed-by" ?

It's probably OK, but please do so if there's another resend.
 Patchwork blindly captures what it sees, so the application has to be
hand modified to change Signed-off-by to Reviewed-by even if you resend
with Reviewed-by.

James
