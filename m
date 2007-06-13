From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: SG TUR and AIO
Date: Thu, 14 Jun 2007 00:59:03 +0200
Message-ID: <1181775543.20149.180.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix2-g20.free.fr ([212.27.60.43]:51878 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXFMWzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 18:55:25 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix2-g20.free.fr (Postfix) with ESMTP id AC78313142DD
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 23:55:57 +0200 (CEST)
Received: from [192.168.0.100] (chn60-1-82-233-48-227.fbx.proxad.net [82.233.48.227])
	by smtp7-g19.free.fr (Postfix) with ESMTP id D078F17F1B
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 00:54:21 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm trying to make multipath daemon checking asynchronous, and most path
checkers use SG. Please bare with some questions on this wild wild topic
(to search engine criteria).

Is it possible to submit through AIO (libaio API) any SG command forged
with struct sg_io_hdr ?

I've seen the INQ example in the sg3_utils package, so I guess it should
work there. But what about "Test Unit Ready" command ?

Also why in the example, only the SG IO write is asynchronous ? Is the
inquiry response read qaranteed to be non-blocking ? Would an pread io
work at all ?

Is there other pointers to code snippets showing these two subsystems
together ?

Thanks for your advices,
cvaroqui

