From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 0/3] scsi_dh_rdac : Support for io-shipping in LSI rdac
 storage
Date: Fri, 8 Apr 2011 11:37:25 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9623@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38124 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757435Ab1DHRgM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2011 13:36:12 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Arumugam, Anburaja" <Anburaja.Arumugam@lsi.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hi everybody,
These series of patches adds support for io-shipping feature in LSI external storage.
This feature provides access to any given LUN via both storage processors as active
but only one of these storage processors owns the LUN. The storage processor which
owns the lun, provides the best performance. The storage processor which does not own
the lun, uses the indirect communication to owning processor.

Signed-off-by: Babu Moger <babu.moger@lsi.com>

