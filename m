From: Joel Soete <joel.soete@tiscali.be>
Subject: Re: [parisc-linux] [PATCH] zalon & ncr53c8xx cleanups
Date: Thu, 11 Sep 2003 21:05:30 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F60E39A.3040901@tiscali.be>
References: <20030911181135.GN21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from spoolo2.tiscali.be ([62.235.13.211]:516 "EHLO
	smtp-out.tiscali.be") by vger.kernel.org with ESMTP id S261528AbTIKVFa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 17:05:30 -0400
In-Reply-To: <20030911181135.GN21596@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: parisc-linux@parisc-linux.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:

>I don't actually have a zalon machine to test these on, but they seem
>right to me, and compile fine.
>
>Some cleanups for ncr53c8xx & zalon:
>
> - Inline zalon.h into zalon.c
> - Rationalise (a little) ncr53c8xx.c's includes
>
I will try to test this last next week on the c110 (which I recover from 
trash) on which I just install debian 3.0r0 cd1 (so still have to update 
to unstable before all)

hth,
    Joel


