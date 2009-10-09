From: Jason White <jason@jasonjgw.net>
Subject: Re: SCSI queue warnings under 2.6.31 with LSI SAS1064E controller
Date: Fri, 9 Oct 2009 22:51:30 +0000 (UTC)
Message-ID: <haoepi$2s4$1@ger.gmane.org>
References: <ham9d4$ihu$1@ger.gmane.org> <0D1E8821739E724A86F4D16902CE275C1C8ED6A4B4@inbmail01.lsi.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:48759 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933443AbZJIWwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Oct 2009 18:52:41 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MwOJf-0005Op-GH
	for linux-scsi@vger.kernel.org; Sat, 10 Oct 2009 00:52:03 +0200
Received: from ppp118-208-189-60.lns10.mel4.internode.on.net ([118.208.189.60])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2009 00:52:03 +0200
Received: from jason by ppp118-208-189-60.lns10.mel4.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2009 00:52:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Desai, Kashyap <Kashyap.Desai@lsi.com> wrote:

>Now coming to the real issue.
>I am suspecting there may be IO errors with your drive coming very frequently.
>
>QUEUE FULL event is coming from Firmware whenever any change happens in
>device queue depth. This will only happens in IO error path. (We can
>think of flow control will kicked off when IO error occurs at firmware
>level and they will inform Driver saying Queue full event).
>
>In other words,
>If you replace with newer SAS drive, things may work fine even with 2.6.31.
>
>As you have mentioned that this SAS drive was previously used for
>striping, there may be possibility of poor performance of your SAS
>drive.

Thanks for the explanation. Is there a safe way to obtain IO error data from the
drives under Linux?

Since they are configured for striping, the two drives appear as a single SCSI
device /dev/sda
The drives are both SEAGATE  ST373454SS


