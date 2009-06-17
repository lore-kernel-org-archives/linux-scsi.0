From: walt <w41ter@gmail.com>
Subject: Re: Question about scsi device names
Date: Wed, 17 Jun 2009 12:56:00 -0700
Message-ID: <h1bhod$d1$1@ger.gmane.org>
References: <h0s7tv$d8f$1@ger.gmane.org> <a43edf1b0906161235h124f3ca0y6f62419c38fcaa84@mail.gmail.com> <h199nr$g7a$1@ger.gmane.org> <20090617141958.GB22727@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:50630 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZFQT4H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 15:56:07 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MH1Eu-0004bL-Av
	for linux-scsi@vger.kernel.org; Wed, 17 Jun 2009 19:56:08 +0000
Received: from adsl-69-234-185-122.dsl.irvnca.pacbell.net ([69.234.185.122])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 19:56:08 +0000
Received: from w41ter by adsl-69-234-185-122.dsl.irvnca.pacbell.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2009 19:56:08 +0000
In-Reply-To: <20090617141958.GB22727@mars.virtualiron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Konrad Rzeszutek wrote:
> On Tue, Jun 16, 2009 at 04:26:58PM -0700, walt wrote:

>> The kernel chooses the root partition based on its own value of rdev,
>
> Which on most distros is the initrd image (/dev/ram0)?
>
> You _need_ to have an initrd image. Then rdev points to (1,0 -
> /dev/ram0) and executes the /init process which takes care of scaning
> the disks for the labels and pivots in a root filesystem depending on the label
> (or the LVM if that is there).

Excellent, thanks very much.  This is the first time in many years I've
had to worry about a vaguely defined root partition, so I forgot about
initrd.

