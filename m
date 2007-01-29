From: Arkadiusz Patyk <areq@areq.eu.org>
Subject: Re: Fw: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Date: Mon, 29 Jan 2007 21:20:56 +0100
Message-ID: <5blsr2hmiqtt1qoqgt7ovchbheovu1hqef@4ax.com>
References: <20070126021907.559f23c9.akpm@osdl.org> <45BA5C30.9050901@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from i9.amg.net.pl ([195.117.14.9]:3930 "EHLO smtp.amg.net.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023AbXA2UrP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 15:47:15 -0500
In-Reply-To: <45BA5C30.9050901@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Fri, 26 Jan 2007 14:53:20 -0500, you wrote:

>Hi,
>
>> I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
>> pciid: 1000:0055
>> mptsas form 2.6.20-rc5 don't recognize it ;(
>> 
>> I see that driver support only 1000:0054 and 1000:0058 devices.
>
>It might be that the device has software RAID feature and changes
>device ID based on setup. (1000:0055 when software RAID is enabled
>and 1000:0054 or something for normal SAS)
>
>If so, there is a chance you can disable the software RAID
>via BIOS setup utility.

Hi,

I can't disable software RAID via BIOS setup utility, but  it's
possible by switch on motherboard. Now is 1000:0054.

Best regards,


-- 
Arkadiusz Patyk [areq<>pld-linux:org] [http://rescuecd.pld-linux.org/]
[IRC:areq skype:arekpatyk  GG:1383 jid:arek<>patyk:net]
