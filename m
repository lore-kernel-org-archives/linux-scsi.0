From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: aix79xx driver status
Date: Thu, 22 Sep 2005 11:52:57 +0200
Message-ID: <ee588a54050922025263ed9a0e@mail.gmail.com>
Reply-To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.203]:698 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030245AbVIVJw7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 05:52:59 -0400
Received: by nproxy.gmail.com with SMTP id x37so29120nfc
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2005 02:52:57 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Age Strand  wrote:

> As far as I understand you the aic7Yxx kernel driver tree is very much
> alive and kicking.

> So what's the deal with the version numbers on the aic79xx driver? It
> has stayed put on 1.1.13 since 2003. Does that mean that there hasn't
> been any new releases of this driver since then?

> I seem to recall seeing submitted patches to aic79xx on the list as late
> as 2004. What's become of those? Is this just a case of patches going in
> but version numbering not being updated?

aic7Yxx drivers have been maintained very badly in the _kernel_ .
Outside, Adaptec people has their own tree.

You can get the latest ADAPTEC patches from:
http://marc.theaimsgroup.com/?a=108731197000012&r=5&w=2
http://marc.theaimsgroup.com/?a=108731197000012&r=4&w=2
under the subject "patch XX/28] Sync up drivers/scsi/aic7xxx".

But maybe,  there are newer patches inside Adaptec,
ask it to Luben Tuikov <luben_tuikov@adaptec.com>


This is a _very critical_ driver and I hope someone take it back to life again.
