From: Alex.Iannicelli@Emulex.Com
Subject: RE: [Patch 4/6] lpfc 8.3.5: Add AER support
Date: Wed, 7 Oct 2009 08:27:28 -0700
Message-ID: <412A05BA40734D4887DBC67661F43308101CA3F0@EXMAIL.ad.emulex.com>
References: <1254511016.32739.23.camel@ogier>
 <87r5tfzqpq.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49541 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZJGP2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2009 11:28:45 -0400
In-Reply-To: <87r5tfzqpq.fsf@basil.nowhere.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andi@firstfloor.org, James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, Alex.Iannicelli@Emulex.Com

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Andi Kleen
> Sent: Wednesday, October 07, 2009 2:03 AM
> To: Smart, James
> Cc: linux-scsi
> Subject: Re: [Patch 4/6] lpfc 8.3.5: Add AER support
> 
> James Smart <James.Smart@Emulex.Com> writes:
> 
> > This patch adds AER support.
> 
> I'm curious -- how did you test that? Did you use the new AER injector
> in 2.6.31?

Yes, we tested it using all the AER error profiles in the AER injector tool.

> 
> -Andi
> 
> --
> ak@linux.intel.com -- Speaking for myself only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
