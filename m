From: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Subject: Sg_ses question
Date: Mon, 21 May 2007 16:39:17 -0000
Message-ID: <861B5CF71BC70C478DFEB9EAFE98F6990233CAA7@G3W0068.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:44012 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbXEUQz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 12:55:26 -0400
Received: from G3W0060.americas.hpqcorp.net (g3w0060.americas.hpqcorp.net [16.232.1.19])
	by ccerelbas03.cce.hp.com (Postfix) with ESMTP id 949043436F
	for <linux-scsi@vger.kernel.org>; Mon, 21 May 2007 11:39:39 -0500 (CDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Not sure if this is the right list for my question but I couldn't find a
more suitable place to ask it.

I'm trying to set the locator light of a disk in a SAS enclosure using
sg_ses but I'm not getting anywhere. I'm dumping the enclosure status
diagnostic page using 'sg_ses --page=2 --raw /dev/sgXX > page' and then
set the SELECT and RQST IDENT bits of the array device element in
question and write it back doing 'sg_ses --control --page=2 --data=-
/dev/sgXX < tmp'. The command completes without error but unfortunately,
nothing happens. When I read the page back, the IDENT bit is still
cleared and the light on the enclosure remains turned off.

Am I doing something wrong or am I missing something? Can't I use sg_ses
to achieve this?

Thanks in advance for any help
...juerg
