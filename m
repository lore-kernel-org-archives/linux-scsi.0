From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] SCSI: update Kconfig help text to indicate SCSI
 core's widespread usage
Date: Sat, 15 Sep 2007 08:16:03 +0200
Message-ID: <46EB78A3.9050404@s5r6.in-berlin.de>
References: <20070914202102.GE5386@csclub.uwaterloo.ca>	<tkrat.f4379d6e5f1ce499@s5r6.in-berlin.de>	<tkrat.0e73b94c1e80a481@s5r6.in-berlin.de> <20070914031256T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59720 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXIOGRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 02:17:08 -0400
In-Reply-To: <20070914031256T.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: lsorense@csclub.uwaterloo.ca, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, jeff@garzik.org, andi@firstfloor.org, folkert@vanheusden.com, bunk@kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> On Fri, 14 Sep 2007 23:14:21 +0200 (CEST)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
...
>> And one more update:
>> There is SAS too,
...
>> +	  You need it
>> +	  - for classic parallel SCSI hardware,
>> +	  - for newer SCSI transports such as Fibre Channel, FireWire storage,
>> +	    SAS, or iSCSI,
> 
> There is SRP too.

I think I'll rewrite it as "for newer SCSI transports such as FireWire
storage."  ;-)

If SRP was in, can 'such as' be omitted?  "for newer SCSI transports
(Fibre Channel, FireWire storage, iSCSI, SAS, SRP),"  Or would be "for
newer SCSI transports such as Fibre Channel, FireWire storage, iSCSI,
SAS, and more," be OK?
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
