From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/9] fnic: FC stat param seconds_since_last_reset not
 getting updated
Date: Fri, 06 Sep 2013 15:52:56 -0700
Message-ID: <1378507976.2063.44.camel@dabdike.int.hansenpartnership.com>
References: <DF334AB4E0858445841A5B5201E1C1B12AE6FF77@xmb-rcd-x08.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48623 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab3IFWw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 18:52:58 -0400
In-Reply-To: <DF334AB4E0858445841A5B5201E1C1B12AE6FF77@xmb-rcd-x08.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>

On Fri, 2013-09-06 at 20:51 +0000, Hiral Patel (hiralpat) wrote:
> Hi James,
> 
> Yes for this patch Narsimhulu Musini is the author of this patch.
> 
> Thanks,
> Hiral
> 
> On 9/6/13 10:35 AM, "James Bottomley"
> <James.Bottomley@HansenPartnership.com> wrote:
> 
> >On Thu, 2013-08-29 at 10:57 -0700, Hiral Patel wrote:
> >> Code to reset fc_host statistics.
> >> echo 1 > /sys/class/fc_host/hostX/statistics/reset_statistics clears
> >>fc_host stats,
> >> the code also issues command to fnic firmware to clear vnic stats.
> >> 
> >> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> >> Signed-off-by: Hiral Patel <hiralpat@cisco.com>
> >
> >Explain this signoff order, please?  It looks from this like Narsimhulu
> >Musini should be the author?

OK, so for all the patches with a different author, you need a

From: A. U. Thor <author@mail.com>

at the beginning and then git will do the right thing.  Please resend
with that done (git-format-patch does this for you).

James


