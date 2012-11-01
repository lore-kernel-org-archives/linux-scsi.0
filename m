From: "Mahesh Rajashekhara" <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 1/1] aacraid: SCSI dma mapping failure case handling
Date: Thu, 1 Nov 2012 07:57:29 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C83926671A505E40@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <1350654667-2304-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com> <508163FD.506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:56016 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761814Ab2KAO5f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Nov 2012 10:57:35 -0400
Content-class: urn:content-classes:message
In-Reply-To: <508163FD.506@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Achim Leubner <Achim.Leubner@pmcs.com>, Tony Ruiz <Tony.Ruiz@pmcs.com>, Tomas Henzl <thenzl@redhat.com>

Hello James,

Can you please let us know the status of this patch. Can we get a
sign-off/approval of this patch.

Thanks,
Mahesh

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Friday, October 19, 2012 8:00 PM
To: Mahesh Rajashekhara
Cc: JBottomley@Parallels.com; linux-scsi@vger.kernel.org;
aacraid@pmc-sierra.com; Achim Leubner; Tony Ruiz
Subject: Re: [PATCH 1/1] aacraid: SCSI dma mapping failure case handling

On 10/19/2012 03:51 PM, Mahesh Rajashekhara wrote:
> Hi James,
>
> We've incorporated the changes suggested by Tomas in this driver
patch.  I would request you to please consider this patch. Please let us
know your comments if any.
>
> Patch Description:
> This patch handles SCSI dma mapping failure case. Reporting error code
to the upper layer instead of BUG_ON().
>
> Signed-off-by: Mahesh Rajashekhara
<Mahesh_Rajashekhara@pmc-sierra.com>

Acked-by: Tomas Henzl <thenzl@redhat.com>

Thanks.

