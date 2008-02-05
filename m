From: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH][drivers/scsi/u14-34f.c] duplicate test 'SCpnt->sc_data_direction
 == DMA_FROM_DEVICE'
Date: Tue, 05 Feb 2008 09:29:07 +0100
Message-ID: <47A81E53.4010504@tiscali.nl>
References: <47A7937C.7040701@tiscali.nl> <59E10AE3DC203E4AAA41B001A2FF2AB8087E25C0@CORPUSMX30B.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54488 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbYBEI3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 03:29:10 -0500
In-Reply-To: <59E10AE3DC203E4AAA41B001A2FF2AB8087E25C0@CORPUSMX30B.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ballabio_Dario@emc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Ballabio_Dario@emc.com wrote:
>  Good to know that somebody still uses the Ultrastor 14f board :).....
> Yes, this typo was introduced by somebody doing massive editing to all
> scsi drivers long ago.
> Cheers,
> --db
Actually, I do not own a Ultrastor 14f board. I found this by searching for
if (test)
...
else if (exactly same test)
...
Thanks,
Roel
