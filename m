From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Mon, 25 Oct 2010 07:16:31 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3010111F73E@cosmail02.lsi.com>
References: <20101023095816.GA19791@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:36736 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab0JYNQ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 09:16:56 -0400
In-Reply-To: <20101023095816.GA19791@apartia.fr>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

You need use LSI application to configure the JBOD before to use it.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Louis-David Mitterrand
Sent: Saturday, October 23, 2010 5:58 AM
To: linux-scsi@vger.kernel.org
Subject: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?

Hi,

On a Dell PowerEdge 2900 III I have a PERC6/i (MegaRaid SAS 1078). From
the controller bios is seems I have to create a "raid0 virtual drive"
for each physical disk or in order for them to appear in Linux.

As I intend to use none of that controller's raid features, is it at all
possible to switch it to plain JBOD mode?

Thanks,
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
