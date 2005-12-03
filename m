From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] aic79xx should be able to ignore HostRAID enabled adapters
Date: Sat, 03 Dec 2005 11:19:01 -0500
Message-ID: <4391C575.6030501@pobox.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E318@otce2k03.adaptec.com> <20051201144745.GI2782@redhat.com> <20051203112208.GC31216@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:3819 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751273AbVLCQTN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Dec 2005 11:19:13 -0500
In-Reply-To: <20051203112208.GC31216@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Heinz Mauelshagen <mauelshagen@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthias Andree wrote:
> In my message I asked whether it was feasible for you to look at
> FreeBSD's "ataraid(4)" driver to learn the Intel ICHx-R SoftRAID format.
> I know FreeBSD understands this format, and dmraid did not when I sent
> the email.

Read the readme :)

http://people.redhat.com/~heinzm/sw/dmraid/readme

The following ATARAID types are supported:

Highpoint HPT37X
Highpoint HPT45X
Intel Software RAID
[...]

