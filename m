From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 11/12] be2iscsi: iscsi boot changes for the kernel
Date: Mon, 5 Jul 2010 16:30:13 -0400
Message-ID: <201007051630.14077.konrad@darnok.org>
References: <20100630000137.GA20320@serverengines.com> <4C30ED31.2020401@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:34419 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0GEUtG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2010 16:49:06 -0400
In-Reply-To: <4C30ED31.2020401@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, Peter Jones <pjones@redhat.com>

On Sunday 04 July 2010 16:21:05 Mike Christie wrote:
> Is this the same patches Konrad is sending? Besides merging them did you
> make changes to the code in his tree? Konrad was going to send it, but

It looks like it. Jayamohan please rebase your code on top 

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git

which is going in 2.6.35.


