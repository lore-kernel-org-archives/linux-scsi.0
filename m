From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH RFC/RFT 01/10] block: add bsg heler library
Date: Sun, 24 Jul 2011 20:32:53 +0200
Message-ID: <4E2C6555.50105@fusionio.com>
References: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu> <1311497964-26842-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58948 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab1GXSdC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 14:33:02 -0400
In-Reply-To: <1311497964-26842-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2011-07-24 10:59, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This moves the FC classes bsg code to the block layer and
> makes it a lib so that other classes like iscsi and SAS can use it.
> 
> It is helpful because working with the request queue, bios,
> creating scatterlists, etc are a pain that the LLD does not
> have to worry about with normal IOs and should not have to
> worry about for bsg requests.

Mike, I'm going to queue this up for post -rc1.

-- 
Jens Axboe

