From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] unsolicited sense in 2.6.0-test5 usb-storage.ko
Date: Tue, 16 Sep 2003 21:28:04 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F66F3C4.4070204@torque.net>
References: <Pine.LNX.4.44L0.0309101700230.1579-100000@ida.rowland.org> <1063229049.6245.12.camel@patehci2> <20030910145252.F13649@one-eyed-alien.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:30085 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S261811AbTIPL3V
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 07:29:21 -0400
In-Reply-To: <20030910145252.F13649@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, stern@rowland.harvard.edu, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

Matthew Dharm wrote:
> On Wed, Sep 10, 2003 at 03:24:09PM -0600, Pat LaVarre wrote:
>
 > <snip/>
> 
>>>Since sgp_dd asked for a 64-byte
>>>READ-CAPACITY, it gets what it deserves.
>>
>>Ah, here we educate me.
>>
>>I should prepare and forward a patch to correct sgp_dd?
>>
>>We the community now broadly accept this rule?  We say apps own the job
>>of keeping the bus "on the thin diagonal" i.e. asking for precisely the
>>expected count of data bytes?
> 
> 
> Yes.

There is a new (beta) version of sg3_utils-1.05.tgz on
http://www.torque.net/sg
that corrects this problem in sgp_dd.


Changelog for sg3_utils-1.05 [20030916]
   - sgp_dd: reduce READ CAPACITY response size to 8 bytes
   - utils/hxascdmp: add utility for displaying ASCII hex
   - sg_readcap: show total size in bytes, MB, GB
   - sg_logs: read log pages twice (first get response length), for
     fragile HBAs
   - sg_modes: fix core dump when corrupted response, don't print
     extra pages
   - sg_iovec.tst: added to examples, for testing sg_iovec
   - sg_map: increase sg device scanning from 128 to 256


Doug Gilbert


