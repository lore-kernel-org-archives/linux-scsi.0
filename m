From: Mark Lord <kernel@teksavvy.com>
Subject: hdparm-9.32 released: recommended upgrade
Date: Fri, 24 Sep 2010 02:30:37 -0400
Message-ID: <4C9C458D.3080703@teksavvy.com>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BF624.7090906@hardwarefreak.com> <20100924013748.GH13116@bombadil.infradead.org> <4C9C1F95.5000509@hardwarefreak.com> <4C9C37B7.7060204@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:2079 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137Ab0IXGaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2010 02:30:39 -0400
In-Reply-To: <4C9C37B7.7060204@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 10-09-24 01:31 AM, Mark Lord wrote:

> hdparm-9.31 is now released, with some fixes to --security,
> and with the nasty warnings mostly removed.

And quickly followed by hdparm-9.32.  Upgrade is RECOMMENDED.

Apparently a number of commands in hdparm have been b0rked since 9.27+,
but nobody bothered to email me about them.  Doh!

Fixed.

(but the libata/libahci AHCI result_tf problem is still an issue).
