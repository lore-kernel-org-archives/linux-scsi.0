From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: SCSI reference
Date: Tue, 01 Sep 2009 13:28:30 +0200
Message-ID: <4A9D055E.7070400@s5r6.in-berlin.de>
References: <48e952f40909010010m1ebbbd95ra72fd42e0de3fbc6@mail.gmail.com> <1C3EB236F2AE4177B8C5F7236DEEF81D@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60057 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbZIAL3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 07:29:03 -0400
In-Reply-To: <1C3EB236F2AE4177B8C5F7236DEEF81D@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: 'Jonathan Nell' <crtrn13@gmail.com>, linux-scsi@vger.kernel.org

jack wang wrote:
[Jonathan Nell wrote]
>> I'm new to this scsi stuff. Is there any good online reference where I
>> can look up CDBs and the format of responses etc.
>> For e.g. I know that  0x43 is READ_TOC but I have no idea how to
>> construct the CDB and what format to response is.
> 
> You should look into t10.org to get SAM SPC SBC specs first , All SCSI
> command & response format could be found there
[...]

To add to that:  If you are not quite satisfied with what you can find 
at http://www.t10.org/ftp/t10/drafts/ nowadays, have a look at 
http://web.archive.org/web/*/http://www.t10.org/ftp/t10/drafts/.
-- 
Stefan Richter
-=====-==--= =--= ----=
http://arcgraph.de/sr/
