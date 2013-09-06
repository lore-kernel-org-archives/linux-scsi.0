From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/9] fnic: FC stat param seconds_since_last_reset not
 getting updated
Date: Fri, 06 Sep 2013 10:35:21 -0700
Message-ID: <1378488921.2063.21.camel@dabdike.int.hansenpartnership.com>
References: <1377799047-12644-1-git-send-email-hiralpat@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45731 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab3IFRfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 13:35:22 -0400
In-Reply-To: <1377799047-12644-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: linux-scsi@vger.kernel.org, Narsimhulu Musini <nmusini@cisco.com>

On Thu, 2013-08-29 at 10:57 -0700, Hiral Patel wrote:
> Code to reset fc_host statistics.
> echo 1 > /sys/class/fc_host/hostX/statistics/reset_statistics clears fc_host stats,
> the code also issues command to fnic firmware to clear vnic stats.
> 
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Hiral Patel <hiralpat@cisco.com>

Explain this signoff order, please?  It looks from this like Narsimhulu
Musini should be the author?

James


