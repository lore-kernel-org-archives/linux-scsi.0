From: Jasper Slits <slits@xs4all.nl>
Subject: Re: latest 2.6 patch for dpt_i20 driver
Date: Mon, 26 Jan 2004 13:09:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040126120908.GA40438@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out3.xs4all.nl ([194.109.24.13]:27908 "EHLO
	smtp-out3.xs4all.nl") by vger.kernel.org with ESMTP id S263653AbUAZMJN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 07:09:13 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: shaeffer@neuralscape.com
Cc: linux-scsi@vger.kernel.org

I managed to get dpt_i2o working with kernel 2.6.1-rc2. 

First of it all, it's still risky to do it. But here is how:

get Mark's patch -> 
http://marc.theaimsgroup.com/?l=linux-scsi&m=107210932819564&w=2

Hack the ./drivers/scsi/dpt_i2o.c and remove all references to the
access_count member. 

The access_count member doesnt exist anymore but is it still included in
the shipped dpt_i2o.c file. I googled some changelogs and it appears to
be removed in a 2.5.x kernel, but correct me if i am wrong. 

it's q&d but it works so far ;)

Compile & boot :)


I enabled bigmem (4GB) and didnt encounter any problems yet. I have to
do some benchmarks bonnie/postal to get a high load for a couple of
hours. Just to make sure it doesnt die ;)


