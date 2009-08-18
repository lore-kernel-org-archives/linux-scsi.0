From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mpt2sas logged messages
Date: Tue, 18 Aug 2009 09:39:45 -0600
Message-ID: <660360F4F2570145BD872F298951B17AE303DAFA@cosmail03.lsi.com>
References: <4A8AAA26.9090706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:41777 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbZHRPkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 11:40:13 -0400
In-Reply-To: <4A8AAA26.9090706@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Cc: Tom Coughlan <coughlan@redhat.com>

On Tuesday, August 18, 2009 7:19 AM,  Ric Wheeler wrote: 
> 
> The second is that the mpt2sas driver spews various messages like:
> 
> Aug 17 06:55:17 megadeth kernel: mpt2sas0: log_info(0x31120102): 
> originator(PL), code(0x12), sub_code(0x0102)

Ric - 

The code (0x12) means PL_LOGINFO_CODE_ABORT
The sub_code(0x102) means PL_LOGINFO_SUB_CODE_OPEN_FAILURE_PATHWAY_BLOCKED

Eric Moore