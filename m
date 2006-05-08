From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] make kernel ignore bogus partitions
Date: Mon, 08 May 2006 16:33:54 +0100
Message-ID: <445F64E2.3000902@dgreaves.com>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net> <20060508072701.GB15941@apps.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s2.ukfsn.org ([217.158.120.143]:652 "EHLO mail.ukfsn.org")
	by vger.kernel.org with ESMTP id S932406AbWEHPgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2006 11:36:02 -0400
In-Reply-To: <20060508072701.GB15941@apps.cwi.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andries Brouwer wrote:
> On Wed, May 03, 2006 at 04:00:55PM -0500, Mike Miller (OS Dev) wrote:
>   
>> Patch 1/1
>> Sometimes partitions claim to be larger than the reported capacity of a
>> disk device. This patch makes the kernel ignore those partitions.
>>     
> Or, while doing forensics on a disk one copies the start to some
> other disk, and that other disk may be smaller.
> Etc.
>
> So, it seems that Linux loses a little bit of its power when such things
> are made impossible.
>   
I've had similar situations when trying to recover data from failed devices.
Equally - if you don't know what's going on then partition/disk size
mismatch is a bad thing.
A loud warning may be more appropriate (and useful) than an ignore.

David
