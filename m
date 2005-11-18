From: Philippe Pegon <Philippe.Pegon@crc.u-strasbg.fr>
Subject: Re: [PATCH 2/3] cciss: bug fix for BIG_PASS_THRU
Date: Fri, 18 Nov 2005 22:05:31 +0100
Message-ID: <437E421B.5060703@crc.u-strasbg.fr>
References: <20051118164112.GA14937@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161244AbVKRVJT@vger.kernel.org>
In-Reply-To: <20051118164112.GA14937@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

mikem wrote:
> Patch 2 of 3
> 
> Applications using CCISS_BIG_PASSTHRU complained that the data written
> was zeros.  The code looked alright, but it seems that copy_from_user 
> already does a memset on the buffer. Removing it from the pass-through
> fixes the apps.
> 
> Please consider this for inclusion.

thanks a lot

--
Philippe Pegon
